import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nomba/data/routine_repository.dart';
import 'package:nomba/domain/routine_model.dart';
import 'package:nomba/domain/schedule_model.dart';

part 'routine_bloc_state.dart';

class RoutineBlocCubit extends Cubit<RoutineBlocState> {
  final RoutineRepository routineRepo;
  Timer? timer;

  RoutineBlocCubit(this.routineRepo) : super(RoutineBlocState(const []));

  // reload routine state to get updated schedules
  void reload() => emit(RoutineBlocState(state.routines));

  // routine reload timer to automatically get updated schedules
  // after every minute
  void startReloadTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      reload();
    });
  }

  // load all routines from local storage
  Future<void> loadRoutines() async {
    try {
      final response = await routineRepo.getRoutines();
      emit(RoutineBlocState(response.toList()));
      startReloadTimer();
    } catch (e) {
      log('$e');
    }
  }

  // create new routine and save to local storage
  Future<String?> createNewRoutine(RoutineModel routineModel) async {
    try {
      final routineList = [routineModel, ...state.routines];
      final response = await routineRepo.saveRoutines(routineList.toSet());
      if (response == false) return 'An error occurred';
      emit(RoutineBlocState(routineList));
      return null;
    } catch (e) {
      log('$e');
      return 'An error occurred';
    }
  }

  // edit a routine and save to local storage
  Future<String?> editRoutine(RoutineModel routineModel) async {
    try {
      final routineList = state.routines
          .map((r) => r.createdAt == routineModel.createdAt ? routineModel : r)
          .toList();
      final response = await routineRepo.saveRoutines(routineList.toSet());
      if (response == false) return 'An error occurred';
      emit(RoutineBlocState(routineList));
      return null;
    } catch (e) {
      log('$e');
      return 'An error occurred';
    }
  }

  // delete a routine and save to local storage
  Future<String?> deleteRoutine(RoutineModel routineModel) async {
    try {
      final routineList = state.routines
          .where((r) => r.createdAt != routineModel.createdAt)
          .toList();
      final response = await routineRepo.saveRoutines(routineList.toSet());
      if (response == false) return 'An error occurred';
      emit(RoutineBlocState(routineList));
      return null;
    } catch (e) {
      log('$e');
      return 'An error occurred';
    }
  }

  Future<String?> markDone({
    required DateTime keyDate,
    required DateTime doneAt,
  }) async {
    try {
      final routineList = state.routines.map((r) {
        if (r.createdAt == keyDate) {
          final doneSessions = {doneAt, ...r.doneSessions};
          return r.copyWith(doneSessions);
        }
        return r;
      }).toList();
      final response = await routineRepo.saveRoutines(routineList.toSet());
      if (response == false) return 'An error occurred';
      emit(RoutineBlocState(routineList));
      return null;
    } catch (e) {
      log('$e');
      return 'An error occurred';
    }
  }

  DateTime? getNextSchedule(RoutineModel model) {
    final selection =
        state.scheduledRoutines.where((s) => s.routineModel == model);
    return selection.isEmpty ? null : selection.first.time;
  }

  // calculates performance by taking percentage of done schedules
  // for that particular routine
  int getRoutinePerformance(RoutineModel model) {
    final doneSelection = state.scheduledRoutines.where(
      (s) => s.routineModel == model && s.status == ScheduleStatus.done,
    );
    final missedSelection = state.scheduledRoutines.where(
      (s) => s.routineModel == model && s.status == ScheduleStatus.missed,
    );
    final performance = (doneSelection.length * 100) /
        (doneSelection.length + missedSelection.length);
    return performance.isNaN ? 0 : performance.round();
  }
}
