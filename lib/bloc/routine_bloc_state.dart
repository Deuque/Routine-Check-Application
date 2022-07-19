part of 'routine_bloc_cubit.dart';

class RoutineBlocState extends Equatable {
  final List<RoutineModel> routines;

  const RoutineBlocState(this.routines);

  @override
  List<Object?> get props => [routines];
}
