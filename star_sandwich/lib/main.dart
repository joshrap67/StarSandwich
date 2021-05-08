import 'package:flutter/material.dart';
import 'package:sphere/sphere.dart';

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
      home: MyHomePage(title: 'Star Sandwich'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double longitude;
  double latitude;

  @override
  void initState() {
    longitude = -14.137293;
    latitude = 27.95309;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(children: [
          IgnorePointer(
            child: Container(
              height: 500,
              child: Sphere(
                surface: 'assets/images/8081_earthmap4k.jpg',
//            surface: 'assets/images/earthspec1k.jpg',
                radius: 100,
                latitude: latitude,
                longitude: longitude,
                alignment: Alignment.center,
              ),
            ),
          ),
          ElevatedButton(onPressed: () {
            latitude = 10;
            longitude = 34;
            setState(() {});
          })
        ]),
      ),
    );
  }
}
