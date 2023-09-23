import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:star_sandwich/imports/globals.dart';
import 'package:star_sandwich/imports/utils.dart';
import 'package:star_sandwich/models/responses/star_response.dart';

class StarDetailsScreen extends StatefulWidget {
  final StarResponse star;
  final bool topStar;

  StarDetailsScreen({required this.star, required this.topStar});

  @override
  _StarDetailsScreenState createState() => _StarDetailsScreenState();
}

class _StarDetailsScreenState extends State<StarDetailsScreen> {
  late String _positionalMsg;

  @override
  void initState() {
    super.initState();

    if (widget.topStar) {
      _positionalMsg = 'This star is directly above you. Look up and try to find it!';
    } else {
      _positionalMsg = 'This star is directly below you. Too bad Earth is in the way!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Star Details'),
        scrolledUnderElevation: 0.0,
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(child: getStarDisplay()),
              Center(child: getNumberOfStarsDisplay()),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Text(
                  _positionalMsg,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              Row(
                children: [
                  Expanded(child: getRightAscensionDisplay()),
                  Expanded(child: getDeclinationDisplay()),
                ],
              ),
              getApparentMagnitudeDisplay(),
              getAbsoluteMagnitudeDisplay(),
              getDistanceDisplay(),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: getConstellationWidget(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getConstellationWidget() {
    return new Container(
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/stars.jpg'), fit: BoxFit.fill)),
      child: Column(
        children: [
          Text(
            '${widget.star.constellation} Constellation',
            style: const TextStyle(fontSize: 18),
          ),
          Text(
            '(${Globals.constellationDescriptions[widget.star.iauConstellation]})',
            style: const TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
          Container(
            height: 150,
            width: double.infinity,
            child: SvgPicture.asset(
              'assets/svgs/${widget.star.iauConstellation}.svg',
            ),
          ),
        ],
      ),
    );
  }

  Widget getApparentMagnitudeDisplay() {
    return new Card(
      child: ListTile(
        title: Text('${widget.star.magnitude}'),
        subtitle: const Text(
          'Apparent Magnitude',
          style: TextStyle(fontSize: 12),
        ),
      ),
    );
  }

  Widget getAbsoluteMagnitudeDisplay() {
    return new Card(
      child: ListTile(
        title:
            Text('${widget.star.absMagnitude} (${widget.star.luminosity.toStringAsFixed(3)}x brighter than the Sun)'),
        subtitle: const Text(
          'Absolute Magnitude',
          style: TextStyle(fontSize: 12),
        ),
      ),
    );
  }

  Widget getDistanceDisplay() {
    double distance = widget.star.distance;
    double lightYears = distance * 3.262;
    return new Card(
      child: ListTile(
        title: Text('$distance parsecs (${lightYears.toStringAsFixed(3)} light years)'),
        subtitle: const Text(
          'Distance from Earth',
          style: TextStyle(fontSize: 12),
        ),
      ),
    );
  }

  Widget getRightAscensionDisplay() {
    return new Card(
      child: ListTile(
        title: Text(
          getFormattedRightAscension(widget.star.rightAscension),
          style: const TextStyle(fontSize: 20),
        ),
        subtitle: const Text(
          'Right Ascension',
          style: TextStyle(fontSize: 12),
        ),
      ),
    );
  }

  Widget getDeclinationDisplay() {
    return new Card(
      child: ListTile(
        title: Text(
          getFormattedDeclination(widget.star.declination),
          style: const TextStyle(fontSize: 20),
        ),
        subtitle: const Text(
          'Declination',
          style: TextStyle(fontSize: 12),
        ),
      ),
    );
  }

  Widget getNumberOfStarsDisplay() {
    var msg = '';
    var numberOfStars = widget.star.numStars;
    if (numberOfStars == 1) {
      msg = 'Single star system';
    } else if (numberOfStars == 2) {
      msg = 'Binary star system';
    } else if (numberOfStars == 3) {
      msg = 'Triple star system';
    }
    return new Text(
      msg,
      style: const TextStyle(fontSize: 26),
    );
  }

  Widget getStarDisplay() {
    return new Text(
      getStarDisplayTitle(widget.star),
      style: const TextStyle(fontSize: 40),
    );
  }
}
