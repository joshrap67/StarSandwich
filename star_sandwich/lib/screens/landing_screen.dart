import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:star_sandwich/models/requests/coordinates.dart';
import 'package:star_sandwich/models/responses/star_response.dart';
import 'package:star_sandwich/screens/sandwich_screen.dart';
import 'package:star_sandwich/services/star_service.dart';
import 'package:star_sandwich/services/location_service.dart';
import 'package:star_sandwich/imports/utils.dart';
import 'package:star_sandwich/imports/validator.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

enum LocationMode { gpsMode, manual }

class _LandingScreenState extends State<LandingScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  LocationMode _locationMode;
  bool _loading;
  StarResponse _topStar;
  StarResponse _bottomStar;
  String _searchAddress;

  @override
  void initState() {
    _locationMode = LocationMode.gpsMode;
    _loading = false;
    _searchAddress = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          hideKeyboard(context);
        },
        child: Container(
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Visibility(
                        visible: _locationMode == LocationMode.manual,
                        child: Row(
                          children: [
                            Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 20.0, 20.0, 20.0)),
                            Expanded(
                              child: Form(
                                key: formKey,
                                child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: const InputDecoration(
                                    icon: Icon(Icons.location_on),
                                    hintText: 'City, zip, address, etc.',
                                    labelText: 'Location',
                                    border: OutlineInputBorder(),
                                  ),
                                  onSaved: (String value) {
                                    _searchAddress = value.trim();
                                  },
                                  validator: validAddress,
                                ),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    20.0, 20.0, 50.0, 20.0)),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: RadioListTile<LocationMode>(
                              value: LocationMode.gpsMode,
                              groupValue: _locationMode,
                              title: Text("GPS"),
                              onChanged: (LocationMode value) {
                                setState(() {
                                  _locationMode = value;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<LocationMode>(
                              value: LocationMode.manual,
                              groupValue: _locationMode,
                              title: Text("Manual"),
                              onChanged: (LocationMode value) {
                                setState(() {
                                  _locationMode = value;
                                });
                              },
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.help_outline),
                            iconSize: 40,
                            tooltip: "Help",
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
      ),
    );
  }

  Future<void> getStars() async {
    setState(() {
      _loading = true;
    });

    Coordinates coordinates;
    try {
      if (_locationMode == LocationMode.manual) {
        coordinates = await getLocFromServer();
      } else if (_locationMode == LocationMode.gpsMode) {
        coordinates = await getLocFromGPS();
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
      final snackBar = SnackBar(
          content: Text('Error making sandwich.${result.errorMessage}'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    setState(() {
      _loading = false;
    });
  }

  Future<Coordinates> getLocFromGPS() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showSnackbar("You must turn on locational services to continue.");
      throw new Exception('Error');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showSnackbar("Locational services must be turned on to use GPS mode.");
        throw new Exception('Error');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showSnackbar(
          "Location permissions are permanently denied, you cannot use GPS mode.");
      throw new Exception('Error');
    }

    Position currentPosition = await Geolocator.getCurrentPosition();
    return new Coordinates(
        longitude: currentPosition.longitude,
        latitude: currentPosition.latitude);
  }

  Future<Coordinates> getLocFromServer() async {
    final form = this.formKey.currentState;
    if (!form.validate()) {
      throw new Exception("Error");
    }

    form.save();
    var result = await LocationService.getGeocodedLocation(_searchAddress);
    if (!result.success) {
      throw new Exception("Error");
    }
    // todo show them the formatted address that was used

    return result.data.coordinates;
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
