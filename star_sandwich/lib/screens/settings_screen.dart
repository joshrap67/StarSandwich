import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:star_sandwich/imports/globals.dart';
import 'package:star_sandwich/imports/utils.dart';
import 'package:star_sandwich/imports/validator.dart';
import 'package:star_sandwich/services/location_service.dart';
import 'package:url_launcher/url_launcher.dart';

import 'about_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

enum LocationMode { gpsMode, manual }

class _SettingsScreenState extends State<SettingsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _locationController = new TextEditingController();

  String _formattedLocation = '';
  LocationMode _locationMode = LocationMode.gpsMode;
  bool _loading = false;
  bool _loadingSharedPrefs = true;
  String _searchAddress = '';
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    getSharedPrefsData();
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingSharedPrefs) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Settings & Info'),
        ),
        body: Container(),
      );
    } else {
      return GestureDetector(
        onTap: () {
          hideKeyboard(context);
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Settings & Info'),
          ),
          body: ListView(
            children: [
              Card(
                child: ListTile(
                  leading: Icon(Icons.location_on),
                  title: Text(
                    'Location',
                    style: TextStyle(fontSize: 25),
                  ),
                  subtitle: Text('Method for determining current location.'),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<LocationMode>(
                      value: LocationMode.gpsMode,
                      groupValue: _locationMode,
                      title: Text('GPS'),
                      onChanged: (LocationMode? value) {
                        setState(() {
                          _locationMode = value!;
                          saveGpsStatusSharedPrefs();
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<LocationMode>(
                      value: LocationMode.manual,
                      groupValue: _locationMode,
                      title: Text('Manual'),
                      onChanged: (LocationMode? value) {
                        setState(() {
                          _locationMode = value!;
                          saveGpsStatusSharedPrefs();
                        });
                      },
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: _locationMode == LocationMode.manual,
                child: Column(
                  children: [
                    Padding(padding: const EdgeInsets.all(5.0)),
                    Row(
                      children: [
                        Padding(padding: const EdgeInsets.all(5.0)),
                        Expanded(
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              decoration: const InputDecoration(
                                hintText: 'City, zip, address, etc.',
                                labelText: 'Location (US/Canada only)',
                                border: OutlineInputBorder(),
                              ),
                              controller: _locationController,
                              onSaved: (String? value) {
                                _searchAddress = value!.trim();
                              },
                              onFieldSubmitted: (value) {
                                getLocFromServer();
                              },
                              validator: validAddress,
                            ),
                          ),
                        ),
                        Container(
                          width: 50,
                          height: 50,
                          child: _loading
                              ? CircularProgressIndicator()
                              : IconButton(
                                  icon: Icon(Icons.search),
                                  onPressed: getLocFromServer,
                                ),
                        ),
                      ],
                    ),
                    Padding(padding: const EdgeInsets.all(5.0)),
                  ],
                ),
              ),
              Padding(padding: const EdgeInsets.all(5.0)),
              Card(
                child: ListTile(
                  leading: Icon(Icons.info),
                  title: Text(
                    'About',
                    style: TextStyle(fontSize: 25),
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return AboutScreen();
                    }));
                  },
                ),
              ),
              Padding(padding: const EdgeInsets.all(5.0)),
              Card(
                child: ListTile(
                  leading: Icon(Icons.privacy_tip),
                  title: Text(
                    'Privacy Policy',
                    style: TextStyle(fontSize: 25),
                  ),
                  onTap: () async {
                    const String url = 'https://star-sandwich-sites.s3.amazonaws.com/privacy_policy.html';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
              ),
              Padding(padding: const EdgeInsets.all(5.0)),
              Card(
                child: ListTile(
                  leading: Icon(Icons.article),
                  title: Text(
                    'Terms of Service',
                    style: TextStyle(fontSize: 25),
                  ),
                  onTap: () async {
                    const String url = 'https://star-sandwich-sites.s3.amazonaws.com/terms_conditions.html';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
              ),
              Padding(padding: const EdgeInsets.all(5.0)),
              Card(
                child: ListTile(
                  leading: Icon(Icons.phone_android),
                  title: Text(
                    _appVersion,
                    style: TextStyle(fontSize: 25),
                  ),
                  subtitle: Text('App Version'),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<void> getLocFromServer() async {
    hideKeyboard(context);
    final form = this._formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    form.save();

    setState(() {
      _loading = true;
    });
    var result = await LocationService.getGeocodedLocation(_searchAddress);
    setState(() {
      _loading = false;
    });

    if (!result.success()) {
      showSnackbar('Cannot determine location. Try making the location more specific.', context);
      return;
    }

    _formattedLocation = result.data!.formattedAddress!;
    _locationController.text = _formattedLocation;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Globals.formattedLocationKey, _formattedLocation);
    await prefs.setDouble(Globals.latitudeKey, result.data!.coordinates!.latitude!);
    await prefs.setDouble(Globals.longitudeKey, result.data!.coordinates!.longitude!);
  }

  Future<void> saveGpsStatusSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(Globals.gpsModeKey, _locationMode == LocationMode.gpsMode);
  }

  Future<void> getSharedPrefsData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      bool gpsPreferred = prefs.getBool(Globals.gpsModeKey) ?? true;
      _locationMode = gpsPreferred ? LocationMode.gpsMode : LocationMode.manual;
      _formattedLocation = prefs.getString(Globals.formattedLocationKey) ?? '';
      _locationController.text = _formattedLocation;
      _appVersion = packageInfo.version;
      _loadingSharedPrefs = false;
    });
  }
}
