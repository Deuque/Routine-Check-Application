import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nomba/bloc/routine_bloc_cubit.dart';
import 'package:nomba/data/routine_repository_impl.dart';
import 'package:nomba/presentation/theme.dart';

import 'presentation/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RoutineBlocCubit(RoutineRepositoryImpl()),
      child: MaterialApp(
        title: 'Nomba Test',
        theme: AppTheme.lightTheme,
        onGenerateRoute: Routes.generateRoute,
        initialRoute: '/',
      ),
    );
  }
}
