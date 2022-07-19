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
      title: Text(model.routineModel.title),
      subtitle: Text(
        '${formattedDate(model.time)} . ${DateFormat.Hm().format(model.time)}',
      ),
      trailing: Text(formattedTimeDifference(model.time)),
    );
  }
}
