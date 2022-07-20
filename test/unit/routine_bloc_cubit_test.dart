import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nomba/bloc/routine_bloc_cubit.dart';
import 'package:nomba/domain/routine_model.dart';

import '../mocks/mock_routine_cubit.dart';
import '../mocks/mock_routine_repository.dart';

void main() {
  late RoutineBlocCubit routineBlocCubit;
  late MockRoutineRepository repo;
  late Set<RoutineModel> sampleResponse;

  setUp(() {
    sampleResponse = {
      RoutineModel(
        title: 'routine1',
        description: 'routine1',
        createdAt: DateTime.now(),
        doneSessions: const {},
        frequency: RoutineFrequency.daily,
      ),
      RoutineModel(
        title: 'routine2',
        description: 'routine2',
        createdAt: DateTime.now(),
        doneSessions: const {},
        frequency: RoutineFrequency.weekly,
      ),
    };
    repo = MockRoutineRepository(sampleResponse);
    routineBlocCubit = MockRoutineCubit(repo);
  });

  blocTest<RoutineBlocCubit, RoutineBlocState>(
    'Routine bloc - loadRoutines',
    build: () => routineBlocCubit,
    act: (bloc) => bloc.loadRoutines(),
    verify: (bloc) {
      // verify that routines are properly fetched from local storage
      expect(bloc.state.routines.length, 2);
      expect(bloc.state.routines, sampleResponse);
    },
  );

  blocTest<RoutineBlocCubit, RoutineBlocState>(
    'Routine bloc - createNewRoutine',
    build: () => routineBlocCubit,
    act: (bloc) => bloc.createNewRoutine(sampleResponse.first),
    verify: (bloc) {
      // verify that creating a new routine inserts the routine into state
      expect(bloc.state.routines.length, 1);
      expect(bloc.state.routines.first, sampleResponse.first);
    },
  );

  blocTest<RoutineBlocCubit, RoutineBlocState>(
    'Routine bloc - editRoutine',
    build: () => routineBlocCubit,
    act: (bloc) async {
      await bloc.loadRoutines();
      await bloc.editRoutine(
        RoutineModel(
          title: 'newRoutine1',
          description: 'newRoutine1',
          createdAt: sampleResponse.first.createdAt,
          doneSessions: sampleResponse.first.doneSessions,
          frequency: sampleResponse.first.frequency,
        ),
      );
    },
    verify: (bloc) {
      // verify that editing a routine changes its value in state.
      // The title of the first routine shows that the
      // routine is successfully changed
      expect(bloc.state.routines.length, 2);
      expect(bloc.state.routines.first.title, 'newRoutine1');
    },
  );

  blocTest<RoutineBlocCubit, RoutineBlocState>(
    'Routine bloc - deleteRoutine',
    build: () => routineBlocCubit,
    act: (bloc) async {
      await bloc.loadRoutines();
      await bloc.deleteRoutine(sampleResponse.first);
    },
    verify: (bloc) {
      // verify that deleting a routine removes it from state
      // first item was successfully removed, leaving only second response
      expect(bloc.state.routines.length, 1);
      expect(bloc.state.routines.first, sampleResponse.last);
    },
  );
}
