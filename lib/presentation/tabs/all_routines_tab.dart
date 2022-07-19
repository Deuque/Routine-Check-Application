import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nomba/bloc/routine_bloc_cubit.dart';
import 'package:nomba/presentation/widgets/routine_layout.dart';

class AllRoutinesTab extends StatelessWidget {
  const AllRoutinesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoutineBlocCubit, RoutineBlocState>(
      builder: (context, state) {
        if (state.routines.isEmpty) {
          // displays an empty routine state
          return _emptyRoutinesView(context);
        }

        // displays loaded routines
        return ListView(
          padding: const EdgeInsets.all(24),
          children: state.routines
              .map((e) => RoutineLayout(routineModel: e))
              .toList(),
        );
      },
    );
  }

  Widget _emptyRoutinesView(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('No available routines'),
          const SizedBox(
            height: 10,
          ),
          OutlinedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/createOrEditRoutine');
            },
            child: const Text('Create a Routine'),
          )
        ],
      );
}
