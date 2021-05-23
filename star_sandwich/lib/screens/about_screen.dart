import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

final double rightAscensionRange = .25;
final double declinationRange = 2.5;

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
          ),
          ListTile(
            title: Text(
              'Star Sandwich determines the nearest star that is directly above you and the nearest star that is directly below you.',
              style: TextStyle(fontSize: 20),
            ),
          ),
          ExpansionTile(
            title: Text('Astronomy Terms'),
            children: [
              ListTile(
                title: Text(
                    '\u2022 Right Ascension: distance, measured in hours, of a point in the sky east of the First Point of Aries.\n\n'
                    '\u2022 Declination: distance, measured in degrees, of a point in the sky north or south of the celestial equator.\n\n'
                    '\u2022 Zenith: point directly over the observer.\n\n'
                    '\u2022 Nadir: point directly below the observer.\n\n'
                    '\u2022 Light year: the distance light travels in one year (approximately 5.87 trillion miles or 9.46 trillion kilometers!)\n\n'),
              )
            ],
          ),
          ExpansionTile(
            title: Text("Disclaimers"),
            children: [
              ListTile(
                title: Text(
                    '\u2022 It\'s not trivial to define "directly above" or "directly below"  when determining the stars to display. '
                    'Distance from the observer\'s zenith/nadir is prioritized, but other factors are also considered as part of the algorithm for determining the star to display.\n\n\Stars are guaranteed to be within \u00B1$declinationRange\u00B0 declination & \u00B1$rightAscensionRange hrs right ascension of the observer\'s zenith and nadir. '),
              ),
              ListTile(
                title: Text(
                    '\u2022 If you want to be cheeky, technically some stars might not be directly above or below you since the light we see is light that was emitted hundreds or even thousands of years ago, so its real position could be somewhere else. This could even warrant more relativisitc discussion involving frames of reference, but for this app\'s sake just embrace the madness.'),
              )
            ],
          ),
          ExpansionTile(
            title: Text('References'),
            children: [
              ListTile(
                title: Text('App Logo drawn by Mike Sexton.'),
              ),
              ListTile(
                title: InkWell(
                  child: Text(
                    'App background image source.',
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                  onTap: () async {
                    const String url =
                        'https://unsplash.com/photos/uhjiu8FjnsQ';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
              ),
              ListTile(
                title: InkWell(
                  child: Text(
                    'Data derived from database found here.',
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                  onTap: () async {
                    const String url =
                        'https://github.com/astronexus/HYG-Database';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
              ),
              ListTile(
                title: InkWell(
                  child: Text(
                    'Earth icon made by Flat Icons (image was modified in implementation).',
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                  onTap: () async {
                    const String url =
                        'https://www.flaticon.com/free-icon/internet_174249';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
