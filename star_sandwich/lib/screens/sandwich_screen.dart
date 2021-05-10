import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:star_sandwich/models/responses/starResponse.dart';
import 'package:star_sandwich/services/star_service.dart';

class SandwichScreen extends StatefulWidget {
  final double latitude;
  final double longitude;
  final StarResponse topStar;
  final StarResponse bottomStar;
  final Location location;

  SandwichScreen(
      {this.latitude,
      this.longitude,
      this.topStar,
      this.bottomStar,
      this.location});

  @override
  _SandwichScreenState createState() => _SandwichScreenState();
}

class _SandwichScreenState extends State<SandwichScreen> {
  double _longitude;
  double _latitude;
  LocationData _currentPosition;
  Location _location;
  StarResponse _topStar;
  StarResponse _bottomStar;
  bool _loading;

  @override
  void initState() {
    _loading = false;
    _latitude = widget.latitude;
    _longitude = widget.longitude;
    _topStar = widget.topStar;
    _bottomStar = widget.bottomStar;
    _location = widget.location;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/stars.png"),
                  fit: BoxFit.fill)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(padding: const EdgeInsets.all(20.0)),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      getStarDisplay(_topStar),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 35,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "${_topStar.constellation} Constellation",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              Hero(
                tag: "heroKey",
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage('assets/images/8081_earthmap4k.jpg')),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "${_bottomStar.constellation} constellation",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      getStarDisplay(_bottomStar),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 35,
                        color: Colors.white,
                      ),
                    ),
                    Padding(padding: const EdgeInsets.all(20.0)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getStars() async {
    _loading = true;
    setState(() {});
    bool locationReceived = await getLoc();
    if (locationReceived) {
      var pos = await _location.getLocation();

      var result =
          await StarService.makeStarSandwich(pos.latitude, pos.longitude);

      if (result.success) {
        _topStar = result.data.starAbove;
        _bottomStar = result.data.starBelow;
      }
    }
    _loading = false;
    setState(() {});
  }

  Future<bool> getLoc() async {
    // todo handle if user did manual here
    _currentPosition = await _location.getLocation();
    return true;
  }

  String getStarDisplay(StarResponse star) {
    if (star.properName.isNotEmpty) {
      return star.properName;
    }
    if (star.bfDesignation.isNotEmpty) {
      return star.bfDesignation;
    }
    if (star.hdId.isNotEmpty) {
      return "HD ${star.hdId}";
    }
    if (star.hrId.isNotEmpty) {
      return "HD ${star.hrId}";
    }
    if (star.hipId.isNotEmpty) {
      return "HD ${star.hipId}";
    }
    if (star.glId.isNotEmpty) {
      return "HD ${star.glId}";
    }
    return "";
  }
}
