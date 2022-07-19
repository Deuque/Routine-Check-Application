import 'package:flutter/material.dart';

class Routines extends StatefulWidget {
  const Routines({Key? key}) : super(key: key);

  @override
  State<Routines> createState() => _RoutinesState();
}

class _RoutinesState extends State<Routines>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Routines'),
        centerTitle: false,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.add))],
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
          controller: controller,
        ),
      ),
    );
  }
}
