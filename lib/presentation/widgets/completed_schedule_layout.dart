import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nomba/bloc/routine_bloc_cubit.dart';
import 'package:nomba/domain/schedule_model.dart';
import 'package:nomba/helpers/date_formatter.dart';

class CompletedScheduleLayout extends StatelessWidget {
  final ScheduleModel model;

  const CompletedScheduleLayout({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.pushNamed(
        context,
        '/viewRoutine',
        arguments: model.routineModel.createdAt,
      ),
      title: Text(model.routineModel.title),
      subtitle: Text(
        '${formattedDate(model.time)} . ${DateFormat.Hm().format(model.time)}',
      ),
      trailing: _trailingWidget(context),
    );
  }

  Widget _trailingWidget(BuildContext context) {
    // show icons for done or missed state,
    // show button to mark done when routine is just completed
    if (model.status == ScheduleStatus.done) {
      return const Icon(
        Icons.check_circle,
        color: Colors.green,
        size: 24,
      );
    } else if (model.status == ScheduleStatus.missed) {
      return const Icon(
        Icons.cancel,
        color: Colors.red,
        size: 24,
      );
    } else if (model.status == ScheduleStatus.inReview) {
      return OutlinedButton(
        onPressed: () {
          BlocProvider.of<RoutineBlocCubit>(context).markDone(
            keyDate: model.routineModel.createdAt,
            doneAt: model.time,
          );
        },
        style: OutlinedButton.styleFrom(
          fixedSize: const Size.fromHeight(20),
        ),
        child: const Text('Mark Done'),
      );
    }

    return const SizedBox.shrink();
  }
}
