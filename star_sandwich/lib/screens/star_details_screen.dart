import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:star_sandwich/imports/globals.dart';
import 'package:star_sandwich/imports/help_messages.dart';
import 'package:star_sandwich/imports/utils.dart';
import 'package:star_sandwich/models/responses/star_response.dart';

class StarDetailsScreen extends StatefulWidget {
  final StarResponse star;
  final bool topStar;

  StarDetailsScreen({this.star, this.topStar});

  @override
  _StarDetailsScreenState createState() => _StarDetailsScreenState();
}

class _StarDetailsScreenState extends State<StarDetailsScreen> {
  String _positionalMsg;

  @override
  void initState() {
    if (widget.topStar) {
      _positionalMsg =
          'This star is directly above you, try and look up if it\'s dark enough!';
    } else {
      _positionalMsg =
          'This star is directly below you. If you can channel your Superman, look through Earth to see it!';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Star Details'),
      ),
      body: Scrollbar(
        child: ListView(
          children: [
            Center(child: getStarDisplay()),
            Center(child: getNumberOfStarsDisplay()),
            Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Text(
                _positionalMsg,
                style: TextStyle(fontSize: 16),
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
    );
  }

  Future<void> showHelpDialog(String title, String message) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message)
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('RETURN'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget getConstellationWidget() {
    return new Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/stars.jpg'), fit: BoxFit.fill)),
      width: 500,
      child: Column(
        children: [
          Text(
            '${widget.star.constellation} Constellation',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            '(${Globals.constellationDescriptions[widget.star.iauConstellation]})',
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
          Container(
            height: 150,
            width: 250,
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
        subtitle: Text('Apparent Magnitude'),
        trailing: IconButton(
          icon: Icon(Icons.help_outline),
          onPressed: () {
			  showHelpDialog(
				  'Apparent Magnitude', HelpMessages.ApparentMagnitude);
          },
        ),
      ),
    );
  }

  Widget getAbsoluteMagnitudeDisplay() {
    return new Card(
      child: ListTile(
        title: Text(
            '${widget.star.absMagnitude} (${widget.star.luminosity.toStringAsFixed(3)}x brighter than the Sun)'),
        subtitle: Text('Absolute Magnitude'),
        trailing: IconButton(
          icon: Icon(Icons.help_outline),
          onPressed: () {
            showHelpDialog(
                'Absolute Magnitude', HelpMessages.AbsoluteMagnitude);
          },
        ),
      ),
    );
  }

  Widget getLuminosityDisplay() {
    return new Card(
      child: ListTile(
          title: Text(
              '${widget.star.luminosity.toStringAsFixed(5)} times more luminous than the Sun.')),
    );
  }

  Widget getDistanceDisplay() {
    double distance = widget.star.distance;
    double lightYears = distance * 3.262;
    return new Card(
      child: ListTile(
        title: Text(
            '$distance parsecs (${lightYears.toStringAsFixed(4)} light years)'),
        subtitle: Text('Distance from Earth'),
      ),
    );
  }

  Widget getRightAscensionDisplay() {
    return new Card(
      child: ListTile(
        title: Text(
          getFormattedRightAscension(widget.star.rightAscension),
          style: TextStyle(fontSize: 20),
        ),
        subtitle: Text('Right Ascension'),
      ),
    );
  }

  Widget getDeclinationDisplay() {
    return new Card(
      child: ListTile(
        title: Text(
          getFormattedDeclination(widget.star.declination),
          style: TextStyle(fontSize: 20),
        ),
        subtitle: Text('Declination'),
      ),
    );
  }

  Widget getNumberOfStarsDisplay() {
    String msg = '';
    int numberOfStars = widget.star.numStars;
    if (numberOfStars == 1) {
      msg = 'Single star system';
    } else if (numberOfStars == 2) {
      msg = 'Binary star system';
    } else if (numberOfStars == 3) {
      msg = 'Triple star system';
    }
    return new Text(
      msg,
      style: TextStyle(fontSize: 26),
    );
  }

  Widget getStarDisplay() {
    StarResponse star = widget.star;
    String msg = '';
    if (star.properName.isNotEmpty) {
      msg = star.properName;
    } else if (star.bfDesignation.isNotEmpty) {
      msg = star.bfDesignation;
    } else if (star.hdId.isNotEmpty) {
      msg = 'HD ${star.hdId}';
    } else if (star.hrId.isNotEmpty) {
      msg = 'HR ${star.hrId}';
    } else if (star.hipId.isNotEmpty) {
      msg = 'HIP ${star.hipId}';
    } else if (star.glId.isNotEmpty) {
      msg = '${star.glId}';
    }
    return new Text(
      msg,
      style: TextStyle(fontSize: 40),
    );
  }
}
