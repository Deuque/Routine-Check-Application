import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nomba/bloc/routine_bloc_cubit.dart';
import 'package:nomba/domain/routine_model.dart';
import 'package:nomba/helpers/string_formatter.dart';

class ViewRoutine extends StatelessWidget {
  final DateTime dateTime;

  const ViewRoutine({
    Key? key,
    required this.dateTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoutineBlocCubit, RoutineBlocState>(
      builder: (context, state) {
        final routineModelSel =
            state.routines.where((element) => element.createdAt == dateTime);
        if (routineModelSel.isEmpty) return const Scaffold();

        final model = routineModelSel.first;
        return _loadedRoutine(context, model);
      },
    );
  }

  Widget _loadedRoutine(BuildContext context, RoutineModel model) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(model.title),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/createOrEditRoutine',
                arguments: model,
              );
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              BlocProvider.of<RoutineBlocCubit>(context).deleteRoutine(model);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Description',
            style: textTheme.caption,
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            model.description,
            style: textTheme.titleMedium,
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            'Frequency',
            style: textTheme.caption,
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            toInitialCaps(model.frequency.name),
            style: textTheme.titleMedium,
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            'Performance',
            style: textTheme.caption,
          ),
        ],
      ),
    );
  }
}
