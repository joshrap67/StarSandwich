import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:star_sandwich/screens/landing_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      title: 'Star Sandwich',
      theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          scaffoldBackgroundColor: const Color(0xff020001),
          brightness: Brightness.dark),
      home: SafeArea(child: LandingScreen()),
    );
  }
}
