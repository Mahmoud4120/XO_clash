import 'package:flutter/material.dart';
import 'package:tic_tac/home_screen.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        primaryColor: Color(0xff00061a),
        shadowColor: Color(0xff001456),
        splashColor: Color(0xff4169e8),
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

