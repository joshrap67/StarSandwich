import 'package:auto_size_text/auto_size_text.dart';
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
  bool _loading = false;
  StarResponse? _topStar;
  StarResponse? _bottomStar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff020001),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/stars.jpg'),
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
                    child: AutoSizeText(
                      'Star Sandwich',
                      textAlign: TextAlign.center,
                      minFontSize: 18,
                      maxLines: 1,
                      style: TextStyle(
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
                                  shape: StadiumBorder(),
                                  backgroundColor: const Color(0xff14cb89),
                                  primary: Colors.black),
                              child: Text(
                                'SANDWICH ME!',
                                style: TextStyle(color: Colors.white, fontSize: 18),
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      Hero(
                        tag: 'heroKey',
                        child: Container(
                          width: MediaQuery.of(context).size.height * .25,
                          height: MediaQuery.of(context).size.height * .25,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            boxShadow: [BoxShadow(color: Color(0xe1a6fac3), blurRadius: 3, spreadRadius: 1)],
                            shape: BoxShape.circle,
                            image: DecorationImage(image: AssetImage('assets/launcher/ic_launcher-playstore.png')),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            customBorder: CircleBorder(),
                            onTap: _loading ? null : () => getStars(),
                          ),
                        ),
                      ),
                      if (_loading)
                        SizedBox(
                            width: MediaQuery.of(context).size.height * .25,
                            height: MediaQuery.of(context).size.height * .25,
                            child: CircularProgressIndicator(
                              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xff00ffa5)),
                            ))
                    ],
                  ),
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

    var result = await StarService.makeStarSandwich(coordinates.latitude!, coordinates.longitude!);

    if (result.success()) {
      _topStar = result.data!.starAbove;
      _bottomStar = result.data!.starBelow;

      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return SandwichScreen(
            latitude: coordinates.latitude!,
            longitude: coordinates.longitude!,
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
    double? latitude = prefs.getDouble(Globals.latitudeKey);
    double? longitude = prefs.getDouble(Globals.longitudeKey);
    if (latitude == null || longitude == null) {
      showSnackbar('Please navigate to the settings page to set a location for manual mode.', context);
      throw new Exception();
    }

    return new Coordinates(latitude: latitude, longitude: longitude);
  }

  Future<Coordinates> getLocFromGPS() async {
    bool serviceEnabled;
    LocationPermission permission;

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

    Position currentPosition = await Geolocator.getCurrentPosition();
    return new Coordinates(longitude: currentPosition.longitude, latitude: currentPosition.latitude);
  }
}
