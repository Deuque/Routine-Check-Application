import 'package:equatable/equatable.dart';
import 'package:nomba/domain/routine_model.dart';

// This model holds schedule information derived from the routines
// This will be used to determine the various states of routines
class ScheduleModel extends Equatable {
  final RoutineModel routineModel;
  final DateTime time;
  final ScheduleStatus status;

  const ScheduleModel({
    required this.routineModel,
    required this.time,
    required this.status,
  });

  @override
  List<Object?> get props => [routineModel, time, status];
}

enum ScheduleStatus { upcoming, next, inReview, done, missed }
