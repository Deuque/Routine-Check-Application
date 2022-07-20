import 'package:flutter_test/flutter_test.dart';
import 'package:nomba/bloc/routine_bloc_cubit.dart';
import 'package:nomba/domain/routine_model.dart';
import 'package:nomba/domain/schedule_model.dart';

void main() {
  test('Routine bloc State Scheduler - Upcoming and missed states', () {
    final model = RoutineModel(
      title: 'routine2',
      description: 'routine2',
      createdAt: DateTime.now().subtract(const Duration(minutes: 25)),
      doneSessions: const {},
      frequency: RoutineFrequency.weekly,
    );
    final routineBlocState = RoutineBlocState([model]);

    // verify that in the past 25 minutes, one routine has expired (after 15 minutes),
    // and the next routine is due in 5 minutes
    expect(routineBlocState.scheduledRoutines, [
      ScheduleModel(
        routineModel: model,
        time: model.createdAt.add(const Duration(minutes: 30)),
        status: ScheduleStatus.upcoming,
      ),
      ScheduleModel(
        routineModel: model,
        time: model.createdAt.add(const Duration(minutes: 15)),
        status: ScheduleStatus.missed,
      ),
    ]);
  });

  test('Routine bloc State Scheduler - NextUp and done states', () {
    final createdAt = DateTime.now().subtract(const Duration(minutes: 16));
    final model = RoutineModel(
      title: 'routine2',
      description: 'routine2',
      createdAt: createdAt,
      doneSessions: {
        createdAt.add(const Duration(minutes: 15)),
      },
      frequency: RoutineFrequency.weekly,
    );
    final routineBlocState = RoutineBlocState([model]);

    // verify that in the past 16 minutes, one routine has expired (after 15 minutes),
    // and the next routine is due in 14 minutes
    expect(routineBlocState.scheduledRoutines, [
      ScheduleModel(
        routineModel: model,
        time: model.createdAt.add(const Duration(minutes: 30)),
        status: ScheduleStatus.next,
      ),
      ScheduleModel(
        routineModel: model,
        time: model.createdAt.add(const Duration(minutes: 15)),
        status: ScheduleStatus.done,
      ),
    ]);
  });
}
