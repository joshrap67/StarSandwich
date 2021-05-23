import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:star_sandwich/imports/globals.dart';
import 'package:star_sandwich/imports/utils.dart';
import 'package:star_sandwich/models/requests/coordinates.dart';
import 'package:star_sandwich/models/responses/star_response.dart';
import 'package:star_sandwich/screens/sandwich_screen.dart';
import 'package:star_sandwich/screens/settings_screen.dart';
import 'package:star_sandwich/services/star_service.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  bool _loading;
  StarResponse _topStar;
  StarResponse _bottomStar;

  @override
  void initState() {
    _loading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff020001),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/stars.jpg"), fit: BoxFit.fill),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AutoSizeText(
                  "Make Me",
                  textAlign: TextAlign.center,
                  minFontSize: 18,
                  style: TextStyle(
                    fontSize: 48,
                    color: Colors.white,
                  ),
                ),
                AutoSizeText(
                  "A",
                  textAlign: TextAlign.center,
                  minFontSize: 18,
                  style: TextStyle(
                    fontSize: 48,
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: AutoSizeText(
                        "Star Sandwich",
                        textAlign: TextAlign.center,
                        minFontSize: 18,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 56,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 20, 12.0, 12.0),
            ),
            Container(
              height: MediaQuery.of(context).size.height * .25,
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: Hero(
                tag: "heroKey",
                child: _loading
                    ? SizedBox(
                        width: MediaQuery.of(context).size.height * .25,
                        height: MediaQuery.of(context).size.height * .25,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              new Color(0xff6f6fee)),
                        ))
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: CircleBorder(), primary: Colors.transparent),
                        child: Container(
                          width: MediaQuery.of(context).size.height * .25,
                          height: MediaQuery.of(context).size.height * .25,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/launcher/splash_logo.png"))),
                        ),
                        onPressed: getStars,
                      ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * .3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return SettingsScreen();
                          }));
                        },
                        icon: Icon(Icons.settings),
                        iconSize: 40,
                        tooltip: "Settings",
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                      ),
                    ],
                  )
                ],
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool gpsMode = prefs.getBool(Globals.gpsModeKey) ?? true;

    Coordinates coordinates;
    try {
      if (gpsMode) {
        coordinates = await getLocFromGPS();
      } else {
        coordinates = await getLocFromSharedPrefs();
      }
    } catch (e) {
      setState(() {
        _loading = false;
      });
      return;
    }

    var result = await StarService.makeStarSandwich(
        coordinates.latitude, coordinates.longitude);

    if (result.success) {
      _topStar = result.data.starAbove;
      _bottomStar = result.data.starBelow;

      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return SandwichScreen(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude,
            bottomStar: _bottomStar,
            topStar: _topStar);
      }));
    } else {
      final snackBar = SnackBar(content: Text('${result.errorMessage}'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    setState(() {
      _loading = false;
    });
  }

  Future<Coordinates> getLocFromSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double latitude = prefs.getDouble(Globals.latitudeKey);
    double longitude = prefs.getDouble(Globals.longitudeKey);
    if (latitude == null || longitude == null) {
      showSnackbar(
          "Please navigate to the settings page to set a location for manual mode.",
          context);
      throw new Exception();
    }

    return new Coordinates(latitude: latitude, longitude: longitude);
  }

  Future<Coordinates> getLocFromGPS() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showSnackbar(
          "You must turn on locational services to continue.", context);
      throw new Exception('Error');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showSnackbar(
            "Locational services must be turned on to use GPS mode.", context);
        throw new Exception('Error');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showSnackbar(
          "Location permissions are permanently denied, you cannot use GPS mode.",
          context);
      throw new Exception('Error');
    }

    Position currentPosition = await Geolocator.getCurrentPosition();
    return new Coordinates(
        longitude: currentPosition.longitude,
        latitude: currentPosition.latitude);
  }
}
