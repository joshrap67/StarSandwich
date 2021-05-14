import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:star_sandwich/models/responses/starResponse.dart';
import 'package:star_sandwich/services/star_service.dart';

class SandwichScreen extends StatefulWidget {
  final double latitude;
  final double longitude;
  final StarResponse topStar;
  final StarResponse bottomStar;

  SandwichScreen(
      {this.latitude, this.longitude, this.topStar, this.bottomStar});

  @override
  _SandwichScreenState createState() => _SandwichScreenState();
}

class _SandwichScreenState extends State<SandwichScreen> {
  double _longitude;
  double _latitude;
  StarResponse _topStar;
  StarResponse _bottomStar;
  bool _loading;
  bool _bottomConstellationShowing;
  bool _topConstellationShowing;

  @override
  void initState() {
    _loading = false;
    _bottomConstellationShowing = false;
    _topConstellationShowing = false;
    _latitude = widget.latitude;
    _longitude = widget.longitude;
    _topStar = widget.topStar;
    _bottomStar = widget.bottomStar;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/stars.jpg"),
                  fit: BoxFit.fill)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _topConstellationShowing =
                                  !_topConstellationShowing;
                            });
                          },
                          icon: Icon(Icons.wb_sunny),
                          iconSize: 35,
                          tooltip: "Star View",
                        ),
                      ],
                    ),
                    _topConstellationShowing
                        ? topConstellationWidget(_topStar)
                        : topStarWidget(_topStar),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.info_outline),
                          iconSize: 35,
                          alignment: Alignment.bottomCenter,
                          tooltip: "Info",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Hero(
                tag: "heroKey",
                child: Container(
                  width: 135,
                  height: 135,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage('assets/images/8081_earthmap4k.jpg')),
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _bottomConstellationShowing =
                                  !_bottomConstellationShowing;
                            });
                          },
                          icon: Icon(Icons.wb_sunny),
                          iconSize: 35,
                          tooltip: "Star View",
                        ),
                      ],
                    ),
                    _bottomConstellationShowing
                        ? bottomConstellationWidget(_bottomStar)
                        : bottomStarWidget(_bottomStar),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.info_outline),
                          iconSize: 35,
                          alignment: Alignment.bottomCenter,
                          tooltip: "Info",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget topStarWidget(StarResponse star) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset(
          'assets/svgs/andromeda.svg',
        ),
        Text(
          "${getStarDisplay(star)}",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  Widget topConstellationWidget(StarResponse star) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset(
          'assets/svgs/canis_major.svg',
        ),
        Text(
          "${star.constellation}",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  Widget bottomStarWidget(StarResponse star) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          "${getStarDisplay(star)}",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontStyle: FontStyle.italic),
        ),
        SvgPicture.asset(
          'assets/svgs/delphinus.svg',
        )
      ],
    );
  }

  Widget bottomConstellationWidget(StarResponse star) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          "${star.constellation}",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontStyle: FontStyle.italic),
        ),
        SvgPicture.asset(
          'assets/svgs/aquarius.svg',
        )
      ],
    );
  }

  Future<void> getStars() async {
    setState(() {
      _loading = true;
    });

    Position currentPosition = await getLocFromGPS();
    if (currentPosition == null) {
      setState(() {
        _loading = false;
      });
      return;
    }
    _latitude = currentPosition.latitude;
    _longitude = currentPosition.longitude;

    var result = await StarService.makeStarSandwich(_latitude, _longitude);

    if (result.success) {
      _topStar = result.data.starAbove;
      _bottomStar = result.data.starBelow;
    } else {
      final snackBar = SnackBar(content: Text('Error making sandwich.'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    setState(() {
      _loading = false;
    });
  }

  Future<Position> getLocFromGPS() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showSnackbar("You must turn on locational services to continue.");
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showSnackbar("Locational services must be turned on to use GPS mode.");
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showSnackbar(
          "Location permissions are permanently denied, you cannot use GPS mode.");
      return null;
    }

    Position currentPosition = await Geolocator.getCurrentPosition();
    return currentPosition;
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  String getStarDisplay(StarResponse star) {
    if (star.properName.isNotEmpty) {
      // todo make this a big deal
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
