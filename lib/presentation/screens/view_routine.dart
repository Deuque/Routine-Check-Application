import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nomba/bloc/routine_bloc_cubit.dart';
import 'package:nomba/domain/routine_model.dart';
import 'package:nomba/helpers/date_formatter.dart';
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
    final nextSchedule =
        BlocProvider.of<RoutineBlocCubit>(context).getNextSchedule(model);
    final performance =
        BlocProvider.of<RoutineBlocCubit>(context).getRoutinePerformance(model);
    final titleStyle =
        textTheme.bodyText2?.copyWith(color: Colors.black.withOpacity(.7));
    final descriptionStyle =
        textTheme.titleMedium?.copyWith(color: Colors.black);

    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: model.title,
          child: Material(
            color: Colors.transparent,
            textStyle: textTheme.titleLarge,
            child: Text(model.title),
          ),
        ),
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
            style: titleStyle,
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            model.description,
            style: descriptionStyle,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Frequency',
            style: titleStyle,
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            toInitialCaps(model.frequency.name),
            style: descriptionStyle,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Next Routine Schedule',
            style: titleStyle,
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            nextSchedule == null
                ? 'N/A'
                : '${formattedDate(nextSchedule)} . ${DateFormat.Hm().format(nextSchedule)}',
            style: descriptionStyle,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Performance',
            style: titleStyle,
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            performance < 70
                ? '😢, Not doing well so far'
                : '👍, Good job! You have over 70% check rate for this routine',
            style: descriptionStyle,
          ),
        ],
      ),
    );
  }
}
