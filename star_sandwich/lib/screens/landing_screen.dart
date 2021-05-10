import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:star_sandwich/models/responses/starResponse.dart';
import 'package:star_sandwich/screens/sandwich_screen.dart';
import 'package:star_sandwich/services/star_service.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

enum LocationMode { gpsMode, manual }

class _LandingScreenState extends State<LandingScreen> {
  LocationMode _locationMode;
  LocationData _currentPosition;
  Location _location;
  bool _loading;
  StarResponse _topStar;
  StarResponse _bottomStar;

  @override
  void initState() {
    _locationMode = LocationMode.gpsMode;
    _loading = false;
    _location = Location();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/stars.png"), fit: BoxFit.fill),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(padding: const EdgeInsets.all(20.0)),
            Expanded(
              child: Column(
                children: [
                  Text(
                    "Make Me",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 48,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "A",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 48,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Star Sandwich",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 48,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Hero(
              tag: "heroKey",
              child: _loading
                  ? SizedBox(
                      width: 150.0,
                      height: 150.0,
                      child: CircularProgressIndicator())
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          primary: new Color(0x9503fca5)),
                      child: Container(
                        width: 150,
                        height: 150,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        child: Icon(
                          Icons.star,
                          size: 75,
                        ),
                      ),
                      onPressed: sandwichButtonPressed,
                    ),
            ),
            Padding(padding: const EdgeInsets.all(50.0)),
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RadioListTile<LocationMode>(
                      value: LocationMode.gpsMode,
                      groupValue: _locationMode,
                      title: Text("GPS Mode"),
                      onChanged: (LocationMode value) {
                        setState(() {
                          _locationMode = value;
                        });
                      },
                    ),
                    RadioListTile<LocationMode>(
                      value: LocationMode.manual,
                      groupValue: _locationMode,
                      title: Text("Manual"),
                      onChanged: (LocationMode value) {
                        setState(() {
                          _locationMode = value;
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.help_outline),
                          iconSize: 35,
                          tooltip: "Help",
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.info_outline),
                          iconSize: 35,
                          tooltip: "Info",
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
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
    // todo try catch to handle errors and stop loading
    _loading = false;
    setState(() {});
  }

  void sandwichButtonPressed() async {
    if (_locationMode == LocationMode.gpsMode) {
      setState(() {
        _loading = true;
      });

      bool locationReceived = await getLoc();
      await getStars();

      if (locationReceived) {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return SandwichScreen(
            latitude: _currentPosition.latitude,
            longitude: _currentPosition.longitude,
            bottomStar: _bottomStar,
            topStar: _topStar,
            location: _location,
          );
        }));
      }
    } else if (_locationMode == LocationMode.manual) {
      // todo prompt user to enter an address
    }
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
