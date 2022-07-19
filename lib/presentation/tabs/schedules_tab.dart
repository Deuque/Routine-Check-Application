import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nomba/bloc/routine_bloc_cubit.dart';
import 'package:nomba/domain/schedule_model.dart';
import 'package:nomba/presentation/widgets/upcoming_schedule_layout.dart';

class ScheduleTab extends StatelessWidget {
  const ScheduleTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoutineBlocCubit, RoutineBlocState>(
      builder: (context, state) {
        final upcomingSchedules = state.scheduledRoutines
            .where((s) => s.status == ScheduleStatus.upcoming);
        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _scheduleGroup(
              'Upcoming',
              Colors.orangeAccent,
              upcomingSchedules
                  .map((e) => UpcomingScheduleLayout(model: e))
                  .toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _scheduleGroup(String title, Color color, List<Widget> content) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, i) => content[i],
            separatorBuilder: (_, __) => const Divider(),
            itemCount: content.length,
          )
        ],
      ),
    );
  }
}
