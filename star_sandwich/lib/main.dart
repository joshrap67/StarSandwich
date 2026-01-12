import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:star_sandwich/imports/theme.dart';
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
          useMaterial3: true,
          colorScheme: darkColorScheme,
          appBarTheme: AppBarTheme(backgroundColor: Colors.black54),
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: <TargetPlatform, PageTransitionsBuilder>{
              TargetPlatform.android: ZoomPageTransitionsBuilder(
                allowEnterRouteSnapshotting: false,
              ),
            },
          ),
          brightness: Brightness.dark),
      home: SafeArea(child: LandingScreen()),
    );
  }
}
