import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nomba/bloc/routine_bloc_cubit.dart';
import 'package:nomba/presentation/tabs/all_routines_tab.dart';

class Routines extends StatefulWidget {
  const Routines({Key? key}) : super(key: key);

  @override
  State<Routines> createState() => _RoutinesState();
}

class _RoutinesState extends State<Routines>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    BlocProvider.of<RoutineBlocCubit>(context).loadRoutines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Routines'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/createOrEditRoutine'),
            icon: const Icon(Icons.add),
          )
        ],
        bottom: TabBar(
          tabs: const ['Schedule', 'All Routines']
              .map(
                (e) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(e),
                ),
              )
              .toList(),
          labelColor: Colors.black,
          unselectedLabelColor: Colors.black54,
          indicatorColor: Colors.black,
          indicatorSize: TabBarIndicatorSize.label,
          controller: _tabController,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [SizedBox.shrink(), AllRoutinesTab()],
      ),
    );
  }
}
