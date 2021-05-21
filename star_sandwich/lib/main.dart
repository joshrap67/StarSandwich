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
          scaffoldBackgroundColor: Colors.white30,
          // ffca8a
          accentColor: const Color(0xff0ef3c5),
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
