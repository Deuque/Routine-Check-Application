part of 'routine_bloc_cubit.dart';

class RoutineBlocState extends Equatable {
  final List<RoutineModel> routines;
  late final DateTime loadedAt;
  late final List<ScheduleModel> scheduledRoutines;

  RoutineBlocState(this.routines) {
    loadedAt = DateTime.now();
    scheduledRoutines = [for (final r in routines) ...scheduleFromRoutine(r)];
    scheduledRoutines.sort((a, b) => b.time.compareTo(a.time));
  }

  List<ScheduleModel> scheduleFromRoutine(RoutineModel model) {
    final schedules = <ScheduleModel>[];
    DateTime dateTime = model.createdAt.add(const Duration(minutes: 15));
    final now = DateTime.now();

    // get schedules from datetime till current time
    while (dateTime.isBefore(now)) {
      ScheduleStatus status = ScheduleStatus.inReview;
      // check if schedule is already marked as done
      if (model.doneSessions.contains(dateTime)) {
        status = ScheduleStatus.done;
      } else {
        final differenceTillNow = now.difference(dateTime).inMinutes;
        // check if schedule lapse time has exceeded 5 minutes
        if (differenceTillNow > 5) {
          status = ScheduleStatus.missed;
        }
      }

      schedules.add(
        ScheduleModel(routineModel: model, time: dateTime, status: status),
      );

      dateTime = dateTime.add(const Duration(minutes: 15));
    }

    // get schedules after current time
    final differenceAfterNow = dateTime.difference(now).inMinutes;
    // check if next schedule is in 5 minutes
    if (differenceAfterNow <= 5) {
      schedules.add(
        ScheduleModel(
          routineModel: model,
          time: dateTime,
          status: ScheduleStatus.upcoming,
        ),
      );
    }
    // check if next schedule is in 12hrs (12x60 minutes)
    else if (differenceAfterNow <= 720) {
      schedules.add(
        ScheduleModel(
          routineModel: model,
          time: dateTime,
          status: ScheduleStatus.next,
        ),
      );
    }

    return schedules;
  }

  @override
  List<Object?> get props => [routines, loadedAt, scheduledRoutines];
}
