import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nomba/domain/schedule_model.dart';
import 'package:nomba/helpers/date_formatter.dart';

class UpcomingScheduleLayout extends StatelessWidget {
  final ScheduleModel model;

  const UpcomingScheduleLayout({
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
      trailing: Text('In ${formattedTimeDifference(model.time)}'),
    );
  }
}
