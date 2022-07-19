import 'package:flutter/material.dart';
import 'package:nomba/domain/routine_model.dart';

class RoutineLayout extends StatelessWidget {
  final RoutineModel routineModel;

  const RoutineLayout({
    Key? key,
    required this.routineModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        '/viewRoutine',
        arguments: routineModel.createdAt,
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    routineModel.title,
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Material(
                    color: Colors.black.withOpacity(.7),
                    borderRadius: BorderRadius.circular(5),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 2.0,
                        horizontal: 6,
                      ),
                      child: Text(
                        routineModel.frequency.name,
                        style: textTheme.caption?.copyWith(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
