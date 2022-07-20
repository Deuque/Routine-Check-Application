import 'package:nomba/bloc/routine_bloc_cubit.dart';

class MockRoutineCubit extends RoutineBlocCubit {
  MockRoutineCubit(super.routineRepo);

  @override
  void startReloadTimer() {}
}

