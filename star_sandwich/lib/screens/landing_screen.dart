import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
  bool _loading;
  StarResponse _topStar;
  StarResponse _bottomStar;

  @override
  void initState() {
    _locationMode = LocationMode.gpsMode;
    _loading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/stars.jpg"), fit: BoxFit.fill),
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
                      onPressed: getStars,
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

  Future<void> getStars() async {
    setState(() {
      _loading = true;
    });

    Position currentPosition = await getLocFromGPS();
    if (currentPosition == null) {
      setState(() {
        _loading = false;
      });
      return;
    }

    var result = await StarService.makeStarSandwich(
        currentPosition.latitude, currentPosition.longitude);

    if (result.success) {
      _topStar = result.data.starAbove;
      _bottomStar = result.data.starBelow;

      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return SandwichScreen(
            latitude: currentPosition.latitude,
            longitude: currentPosition.longitude,
            bottomStar: _bottomStar,
            topStar: _topStar);
      }));
    } else {
      final snackBar = SnackBar(content: Text('Error making sandwich.'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    setState(() {
      _loading = false;
    });
  }

  Future<Position> getLocFromGPS() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showSnackbar("You must turn on locational services to continue.");
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showSnackbar("Locational services must be turned on to use GPS mode.");
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showSnackbar(
          "Location permissions are permanently denied, you cannot use GPS mode.");
      return null;
    }

    Position currentPosition = await Geolocator.getCurrentPosition();
    return currentPosition;
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
