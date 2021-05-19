import 'package:flutter/material.dart';
import 'package:star_sandwich/models/responses/star_response.dart';

class StarDetailsScreen extends StatefulWidget {
  final StarResponse star;
  final bool topStar;

  StarDetailsScreen({this.star, this.topStar});

  @override
  _StarDetailsScreenState createState() => _StarDetailsScreenState();
}

class _StarDetailsScreenState extends State<StarDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Star Details"),
      ),
      body: ListView(
        children: [
          Text(getStarDisplay(widget.star)),
          widget.topStar
              ? Text(
                  "This star is directly above you, try and look up if it's dark enough!")
              : Text(
                  "This star is directly below you. If you can channel your superman, look through the Earth to see it!"),
          Text(widget.star.rightAscension.toString()),
          // todo format to hrs
          Text(widget.star.declination.toString())
        ],
      ),
    );
  }

  String getStarDisplay(StarResponse star) {
    if (star.properName.isNotEmpty) {
      // todo make this a big deal?
      return star.properName;
    }
    if (star.bfDesignation.isNotEmpty) {
      return star.bfDesignation;
    }
    if (star.hdId.isNotEmpty) {
      return "HD ${star.hdId}";
    }
    if (star.hrId.isNotEmpty) {
      return "HR ${star.hrId}";
    }
    if (star.hipId.isNotEmpty) {
      return "HIP ${star.hipId}";
    }
    if (star.glId.isNotEmpty) {
      return "${star.glId}";
    }
    return "";
  }
}
