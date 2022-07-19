import 'package:flutter/material.dart';
import 'package:nomba/presentation/routines.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nomba Test',
      theme: ThemeData(
        primaryColorDark: Colors.black,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.black),
          shadowColor: Colors.grey[100],
        ),
      ),
      home: const Routines(),
    );
  }
}
