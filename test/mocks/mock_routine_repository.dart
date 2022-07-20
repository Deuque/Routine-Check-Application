import 'package:nomba/data/routine_repository.dart';
import 'package:nomba/domain/routine_model.dart';

class MockRoutineRepository implements RoutineRepository {
  final Set<RoutineModel> response;

  MockRoutineRepository(this.response);

  @override
  Future<Set<RoutineModel>> getRoutines() {
    return Future.value(response);
  }

  @override
  Future<bool> saveRoutines(Set<RoutineModel> routines) {
    return Future.value(true);
  }
}
