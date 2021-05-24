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
          accentColor: const Color(0xff6f6fee),
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.blue,
            selectionColor: Colors.white30,
            selectionHandleColor: Colors.greenAccent,
          ),
          brightness: Brightness.dark),
      home: SafeArea(child: LandingScreen()),
    );
  }
}
