import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:star_sandwich/screens/landing_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      title: 'Star Sandwich',
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.blue,
          selectionColor: Colors.white30,
          selectionHandleColor: Colors.greenAccent,
        ),
        appBarTheme: AppBarTheme(color: Colors.black54),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Color(0xff29d49e)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              style: BorderStyle.solid,
              color: const Color(0xff00ffa5),
              width: 2,
            ),
          ),
        ),
        brightness: Brightness.dark,
      ),
      home: SafeArea(child: LandingScreen()),
    );
  }
}
