import 'package:flutter/material.dart';
import 'package:sphere/sphere.dart';
import 'package:location/location.dart';
import 'package:star_sandwich/models/responses/starResponse.dart';
import 'package:star_sandwich/services/star_service.dart';

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
  double _longitude;
  double _latitude;
  LocationData _currentPosition;
  Location _location;
  StarResponse _topStar;
  StarResponse _bottomStar;
  bool _loading;

  @override
  void initState() {
    _longitude = -14.137293;
    _latitude = 77.95309;
    _location = Location();
    _loading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          if (_topStar != null) Text("Top star ${_topStar.constellation}"),
          Container(
            height: 500,
            child: Sphere(
              surface: 'assets/images/8081_earthmap4k.jpg',
//            surface: 'assets/images/earthspec1k.jpg',
              radius: 100,
              latitude: _latitude,
              longitude: _longitude,
              alignment: Alignment.center,
            ),
          ),
          if (_bottomStar != null)
            Text("Bottom star ${_bottomStar.constellation}"),
          ElevatedButton(
              child: Text("Make me a star sandwich"),
              onPressed: () {
                getStars();
              }),
          if (_loading) CircularProgressIndicator()
        ]),
      ),
    );
  }

  getStars() async {
    _loading = true;
    setState(() {});
    bool locationReceived = await getLoc();
    if (locationReceived) {
      var result = await StarService.makeStarSandwich(
          _currentPosition.latitude, _currentPosition.longitude);

      if (result.success) {
        _topStar = result.data.starAbove;
        _bottomStar = result.data.starBelow;
      }
    }
    _loading = false;
    setState(() {});
  }

  Future<bool> getLoc() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return false;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }

    _currentPosition = await _location.getLocation();
    return true;
  }
}
