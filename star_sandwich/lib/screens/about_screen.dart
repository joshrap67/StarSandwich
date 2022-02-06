import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

final double rightAscensionRange = 0.1;
final double declinationRange = 1.0;

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Scrollbar(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
            ),
            ListTile(
              title: const Text(
                'Star Sandwich determines the nearest star that is directly above you and the nearest star that is directly below you.\n\n'
					'Just click the button on the landing screen to get started!',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ExpansionTile(
              title: const Text('Astronomy Terms'),
              children: [
                ListTile(
                  title: const Text(
                      '\u2022 Right Ascension: distance, measured in hours, of a point in the sky east of the First Point of Aries.\n\n'
                      '\u2022 Declination: distance, measured in degrees, of a point in the sky north or south of the celestial equator.\n\n'
                      '\u2022 Zenith: point in the sky directly over the observer.\n\n'
                      '\u2022 Nadir: point in the sky directly below the observer.\n\n'
                      '\u2022 Apparent magnitude: measure of how bright an object is relative to Earth. The smaller the number, the brighter the object appears.\nObjects with an apparent magnitude greater than around 6 are not visible to the naked human eye.\n\n'
                      '\u2022 Absolute magnitude: intrinsic measure of how bright an object is measured from a fixed position of 10 parsecs. Like with apparent magnitude, the smaller the number the brighter the object.\nThe scale is logarithmic. If the difference between the absolute magnitude of two stars is 5, then their brightness differs by a factor of 100.\n\n'
                      '\u2022 Light year: distance light travels in one year (approximately 5.87 trillion miles or 9.46 trillion kilometers!)'),
                )
              ],
            ),
            ExpansionTile(
              title: const Text('Disclaimers'),
              children: [
                ListTile(
                  title: Text(
                      '\u2022 When determining "directly above" or "directly below" stars are guaranteed to be within \u00B1$declinationRange\u00B0 declination & \u00B1$rightAscensionRange hrs right ascension of the observer\'s zenith and nadir.'
                      '\n\nAngular distance from the observer\'s zenith/nadir is prioritized, but other factors are also considered as part of the algorithm for determining the star to display.'),
                ),
                ListTile(
                  title: const Text(
                      '\u2022 If you want to be cheeky, technically some stars might not be directly above or below you since the light we see is light that was emitted hundreds or even thousands of years ago, so its real position could be somewhere else. This could even warrant more relativisitc discussion involving reference frames, but for this app\'s sake just embrace the madness.'),
                )
              ],
            ),
            ExpansionTile(
              title: const Text('References'),
              children: [
                ListTile(
                  title: const Text('App Logo drawn by Mike O. Sexton.'),
                ),
                ListTile(
                  title: InkWell(
                    child: const Text(
                      'App background image source.',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    onTap: () async {
                      const String url = 'https://unsplash.com/photos/uhjiu8FjnsQ';
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
                    child: const Text(
                      'Selected data from AstroNexus database.',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    onTap: () async {
                      const String url = 'https://github.com/astronexus/HYG-Database';
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
      ),
    );
  }
}
