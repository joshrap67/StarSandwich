import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:star_sandwich/models/responses/star_response.dart';
import 'package:star_sandwich/screens/star_details_screen.dart';

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
  bool _bottomConstellationShowing;
  bool _topConstellationShowing;
  double _bottomStarRotation;
  double _topStarRotation;

  @override
  void initState() {
    final random = new Random();
    _topStarRotation = random.nextInt(360).toDouble();
    _bottomStarRotation = random.nextInt(360).toDouble();
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
        backgroundColor: const Color(0xff020001),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/stars.jpg"),
                  fit: BoxFit.fill)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  child: _topStar != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15, bottom: 15)),
                                  BackButton(),
                                ],
                              ),
                            ),
                            _topConstellationShowing
                                ? topConstellationWidget(_topStar)
                                : topStarWidget(_topStar),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15, bottom: 15)),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _topConstellationShowing =
                                            !_topConstellationShowing;
                                      });
                                    },
                                    icon: _topConstellationShowing
                                        ? Icon(Icons.wb_sunny)
                                        : Icon(Icons.map),
                                    iconSize: 35,
                                    tooltip: _topConstellationShowing
                                        ? "Star View"
                                        : "View Constellation",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : topStarNotFoundWidget()),
              Hero(
                tag: "heroKey",
                child: Container(
                  width: 135,
                  height: 135,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage('assets/images/MODIS_Map.jpg')),
                  ),
                ),
              ),
              Expanded(
                child: _bottomStar != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Spacer(),
                          _bottomConstellationShowing
                              ? bottomConstellationWidget(_bottomStar)
                              : bottomStarWidget(_bottomStar),
                          Visibility(
                            visible: _bottomStar != null,
                            child: Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _bottomConstellationShowing =
                                            !_bottomConstellationShowing;
                                      });
                                    },
                                    icon: _bottomConstellationShowing
                                        ? Icon(Icons.wb_sunny)
                                        : Icon(Icons.map),
                                    iconSize: 35,
                                    tooltip: _bottomConstellationShowing
                                        ? "Star View"
                                        : "View Constellation",
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15, bottom: 15)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : bottomStarNotFoundWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget topStarNotFoundWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            BackButton(),
            Container(
              child: Text(
                "No star found.\nWho knows what could be above you...",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget bottomStarNotFoundWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          child: Text(
            "No star found.\nWho knows what could be below you...",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget topStarWidget(StarResponse star) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return StarDetailsScreen(star: star, topStar: true);
        }));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 100,
            width: 200,
            child: Transform.rotate(
              angle: _topStarRotation,
              child: Image.asset(
                getStarImage(star),
              ),
            ),
          ),
          Text(
            "${getStarDisplay(star)}",
            textAlign: TextAlign.center,
            style: TextStyle(
                decoration: TextDecoration.underline,
                fontSize: 30,
                color: Colors.white,
                fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget topConstellationWidget(StarResponse star) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return StarDetailsScreen(star: star, topStar: true);
        }));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 150,
            width: 200,
            child: SvgPicture.asset(
              'assets/svgs/${star.iauConstellation}.svg',
            ),
          ),
          Text(
            "${star.constellation} Constellation",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget bottomStarWidget(StarResponse star) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return StarDetailsScreen(star: star, topStar: false);
        }));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "${getStarDisplay(star)}",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
              decoration: TextDecoration.underline,
            ),
          ),
          Container(
            height: 100,
            width: 200,
            child: Transform.rotate(
              angle: _bottomStarRotation,
              child: Image.asset(
                getStarImage(star),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget bottomConstellationWidget(StarResponse star) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return StarDetailsScreen(star: star, topStar: true);
        }));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "${star.constellation} Constellation",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontStyle: FontStyle.italic),
          ),
          Container(
            height: 150,
            width: 200,
            child: SvgPicture.asset(
              'assets/svgs/${star.iauConstellation}.svg',
            ),
          )
        ],
      ),
    );
  }

  String getStarImage(StarResponse star) {
    String image;
    if (star.magnitude < 3) {
      image = 'assets/images/very_bright.png';
    } else if (star.magnitude < 6) {
      image = 'assets/images/bright.png';
    } else {
      image = 'assets/images/dim.png';
    }
    return image;
  }

  String getStarDisplay(StarResponse star) {
    String response = "";
    if (star.properName.isNotEmpty) {
      response = star.properName;
    } else if (star.bfDesignation.isNotEmpty) {
      response = star.bfDesignation;
    } else if (star.hdId.isNotEmpty) {
      response = "HD ${star.hdId}";
    } else if (star.hrId.isNotEmpty) {
      response = "HR ${star.hrId}";
    } else if (star.hipId.isNotEmpty) {
      response = "HIP ${star.hipId}";
    } else if (star.glId.isNotEmpty) {
      response = "${star.glId}";
    }
    return response;
  }
}
