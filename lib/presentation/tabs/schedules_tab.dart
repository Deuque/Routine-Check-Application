import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nomba/bloc/routine_bloc_cubit.dart';
import 'package:nomba/domain/schedule_model.dart';
import 'package:nomba/presentation/widgets/completed_schedule_layout.dart';
import 'package:nomba/presentation/widgets/upcoming_schedule_layout.dart';

class ScheduleTab extends StatelessWidget {
  const ScheduleTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoutineBlocCubit, RoutineBlocState>(
      builder: (context, state) {
        final upcomingSchedules = state.scheduledRoutines
            .where((s) => s.status == ScheduleStatus.upcoming);
        final nextUpSchedules = state.scheduledRoutines
            .where((s) => s.status == ScheduleStatus.next);
        final completedSchedules = state.scheduledRoutines.where(
          (s) => [
            ScheduleStatus.inReview,
            ScheduleStatus.done,
            ScheduleStatus.missed
          ].contains(s.status),
        );
        return RefreshIndicator(
          onRefresh: () async =>
              BlocProvider.of<RoutineBlocCubit>(context).reload(),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _ScheduleGroup(
                title: 'Upcoming',
                description: 'Routines that will happen within 5 minutes',
                color: Colors.orange,
                scheduleItems: upcomingSchedules
                    .map((e) => UpcomingScheduleLayout(model: e))
                    .toList(),
              ),
              const SizedBox(
                height: 20,
              ),
              _ScheduleGroup(
                title: 'Next Up',
                description: 'Routines that will happen within 12hrs',
                color: Colors.blue,
                scheduleItems: nextUpSchedules
                    .map((e) => UpcomingScheduleLayout(model: e))
                    .toList(),
              ),
              const SizedBox(
                height: 20,
              ),
              _ScheduleGroup(
                title: 'Completed',
                description:
                    'Routines that are completed, whether done, missed, or in review',
                color: Colors.green,
                scheduleItems: completedSchedules
                    .map((e) => CompletedScheduleLayout(model: e))
                    .toList(),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ScheduleGroup extends StatelessWidget {
  final String title;
  final String description;
  final Color color;
  final List<Widget> scheduleItems;

  const _ScheduleGroup({
    Key? key,
    required this.title,
    required this.description,
    required this.color,
    required this.scheduleItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () => _showHint(context, title, description),
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(.8),
                      ),
                    ),
                    Icon(
                      Icons.help_outline,
                      color: Colors.white.withOpacity(.9),
                    )
                  ],
                ),
              ),
            ),
          ),
          if (scheduleItems.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text('No $title routines'),
              ),
            )
          else
            ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, i) => scheduleItems[i],
              separatorBuilder: (_, __) => const Divider(),
              itemCount: scheduleItems.length,
            )
        ],
      ),
    );
  }

  void _showHint(BuildContext context, String title, String description) {
    final textTheme = Theme.of(context).textTheme;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: textTheme.titleMedium,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              description,
              style: textTheme.bodyLarge,
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
