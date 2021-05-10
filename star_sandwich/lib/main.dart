import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:star_sandwich/screens/landing_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Star Sandwich',
      theme: ThemeData(
          primarySwatch: Colors.deepPurple, brightness: Brightness.dark),
      home: SafeArea(child: LandingScreen()),
    );
  }
}
