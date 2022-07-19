import 'package:flutter/cupertino.dart';
import 'package:nomba/domain/routine_model.dart';
import 'package:nomba/presentation/screens/create_or_edit_routine.dart';
import 'package:nomba/presentation/screens/routines.dart';
import 'package:nomba/presentation/screens/view_routine.dart';

class Routes {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return CupertinoPageRoute(builder: (_) => const Routines());
      case '/createOrEditRoutine':
        return CupertinoPageRoute(
          builder: (_) => CreateOrEditRoutine(
            routineModel: settings.arguments as RoutineModel?,
          ),
        );
      case '/viewRoutine':
        return CupertinoPageRoute(
          builder: (_) => ViewRoutine(
            dateTime: settings.arguments as DateTime,
          ),
        );
    }

    return null;
  }
}
