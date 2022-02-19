import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:star_sandwich/imports/globals.dart';
import 'package:star_sandwich/imports/utils.dart';
import 'package:star_sandwich/models/requests/coordinates.dart';
import 'package:star_sandwich/screens/sandwich_screen.dart';
import 'package:star_sandwich/screens/settings_screen.dart';
import 'package:star_sandwich/services/star_service.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff020001),
      body: Container(
        decoration: const BoxDecoration(
          image: const DecorationImage(
            image: const AssetImage('assets/images/stars.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 40.0, 8.0, 0.0),
                    child: const AutoSizeText(
                      'Star Sandwich',
                      textAlign: TextAlign.center,
                      minFontSize: 18,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 60,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.height * .25,
                            child: OutlinedButton(
                              onPressed: _loading ? null : () => getStars(),
                              style: OutlinedButton.styleFrom(
                                  shape: const StadiumBorder(),
                                  backgroundColor: const Color(0xff2d6280),
                                  primary: Colors.black),
                              child: const Text(
                                'SANDWICH ME!',
                                style: const TextStyle(color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 15.0),
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) {
                                  return SettingsScreen();
                                }),
                              );
                            },
                            icon: const Icon(Icons.settings),
                            iconSize: 40,
                            tooltip: 'Settings',
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Center(
              child: Stack(
                children: [
                  Hero(
                    tag: 'heroKey',
                    child: Container(
                      width: MediaQuery.of(context).size.height * .25,
                      height: MediaQuery.of(context).size.height * .25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: const DecorationImage(
                          image: const AssetImage('assets/images/earth.png'),
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: _loading ? null : () => getStars(),
                      ),
                    ),
                  ),
                  if (_loading)
                    SizedBox(
                      width: MediaQuery.of(context).size.height * .25,
                      height: MediaQuery.of(context).size.height * .25,
                      child: const CircularProgressIndicator(
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xff00ffa5)),
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getStars() async {
    setState(() {
      _loading = true;
    });
    var prefs = await SharedPreferences.getInstance();
    var gpsMode = prefs.getBool(Globals.gpsModeKey) ?? true;

    var coordinates;
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

    var result = await StarService.makeStarSandwich(coordinates.latitude!, coordinates.longitude!);

    if (result.success()) {
      var topStar = result.data!.starAbove;
      var bottomStar = result.data!.starBelow;

      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return SandwichScreen(
            latitude: coordinates.latitude!,
            longitude: coordinates.longitude!,
            bottomStar: bottomStar,
            topStar: topStar);
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
    var latitude = prefs.getDouble(Globals.latitudeKey);
    var longitude = prefs.getDouble(Globals.longitudeKey);
    if (latitude == null || longitude == null) {
      showSnackbar('Please navigate to the settings page to set a location for manual mode.', context);
      throw new Exception();
    }

    return new Coordinates(latitude: latitude, longitude: longitude);
  }

  Future<Coordinates> getLocFromGPS() async {
    var serviceEnabled;
    var permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showSnackbar('You must turn on locational services to continue.', context);
      throw new Exception('Error');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showSnackbar('Locational services must be turned on to use GPS mode.', context);
        throw new Exception('Error');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showSnackbar('Location permissions are permanently denied, you cannot use GPS mode.', context);
      throw new Exception('Error');
    }

    var currentPosition = await Geolocator.getCurrentPosition();
    return new Coordinates(longitude: currentPosition.longitude, latitude: currentPosition.latitude);
  }
}
