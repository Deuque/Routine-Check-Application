import 'package:nomba/domain/routine_model.dart';

abstract class RoutineRepository {
  Future<Set<RoutineModel>> getRoutines();

  Future<bool> saveRoutines(Set<RoutineModel> routines);
}
