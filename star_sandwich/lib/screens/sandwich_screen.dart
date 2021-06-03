import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
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

class _SandwichScreenState extends State<SandwichScreen>
    with SingleTickerProviderStateMixin {
  StarResponse _topStar;
  StarResponse _bottomStar;
  bool _bottomConstellationShowing;
  double _width;
  bool _topConstellationShowing;
  Animation<double> _starRotation;
  AnimationController _animationControl;

  @override
  void initState() {
    _bottomConstellationShowing = false;
    _topConstellationShowing = false;
    _topStar = widget.topStar;
    _bottomStar = widget.bottomStar;

    _animationControl = AnimationController(
      duration: Duration(seconds: 40),
      vsync: this,
    );

    _starRotation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).animate(_animationControl);
    _animationControl.repeat();

    super.initState();
  }

  @override
  void dispose() {
    _animationControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
	  _width = MediaQuery.of(context).size.width * 0.6;

	  return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff020001),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/stars.jpg'),
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
                            Container(
                              width: _width,
                              child: _topConstellationShowing
                                  ? topConstellationWidget(_topStar)
                                  : topStarWidget(_topStar),
                            ),
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
                                        ? 'Star View'
                                        : 'View Constellation',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : topStarNotFoundWidget()),
              Hero(
                tag: 'heroKey',
                child: Tooltip(
                  message: '${widget.latitude}°, ${widget.longitude}°',
                  child: Container(
                    width: MediaQuery.of(context).size.height * .25,
                    height: MediaQuery.of(context).size.height * .25,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage('assets/images/middle.png')),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _bottomStar != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Spacer(),
                          Container(
                            width: _width,
                            child: _bottomConstellationShowing
                                ? bottomConstellationWidget(_bottomStar)
                                : bottomStarWidget(_bottomStar),
                          ),
                          Expanded(
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
                                      ? 'Star View'
                                      : 'View Constellation',
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15, bottom: 15)),
                              ],
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

  Widget topStarWidget(StarResponse star) {
    return GestureDetector(
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
            width: _width,
            child: AnimatedBuilder(
              animation: _animationControl,
              builder: (_, child) => Transform(
                transform: Matrix4.rotationZ(_starRotation.value),
                alignment: Alignment.center,
                child: Image.asset(
                  getStarImage(star),
                ),
              ),
            ),
          ),
          Expanded(
            child: AutoSizeText(
              '${getStarDisplay(star)}',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              minFontSize: 14,
              maxLines: 2,
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 30,
                  color: Colors.white,
                  fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }

  Widget topConstellationWidget(StarResponse star) {
    return GestureDetector(
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
            width: _width,
            child: SvgPicture.asset(
              'assets/svgs/${star.iauConstellation}.svg',
            ),
          ),
          Expanded(
            child: AutoSizeText(
              '${star.constellation} Constellation',
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              minFontSize: 14,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontStyle: FontStyle.italic),
            ),
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
          AutoSizeText(
            '${getStarDisplay(star)}',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            minFontSize: 14,
            maxLines: 2,
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
              decoration: TextDecoration.underline,
            ),
          ),
          Container(
            height: 100,
            width: _width,
            child: AnimatedBuilder(
              animation: _animationControl,
              builder: (_, child) => Transform(
                transform: Matrix4.rotationZ(_starRotation.value),
                alignment: Alignment.center,
                child: Image.asset(
                  getStarImage(star),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget bottomConstellationWidget(StarResponse star) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return StarDetailsScreen(star: star, topStar: false);
        }));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AutoSizeText(
            '${star.constellation} Constellation',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            minFontSize: 14,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontStyle: FontStyle.italic),
          ),
          Container(
            height: 150,
            width: _width,
            child: SvgPicture.asset(
              'assets/svgs/${star.iauConstellation}.svg',
            ),
          )
        ],
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
            Expanded(
              child: AutoSizeText(
                'No star found.\nWho knows what could be above you...',
                textAlign: TextAlign.center,
                minFontSize: 12,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
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
        AutoSizeText(
          'No star found.\nWho knows what could be below you...',
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          minFontSize: 14,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ],
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
    String response = '';
    if (star.properName.isNotEmpty) {
      response = star.properName;
    } else if (star.bfDesignation.isNotEmpty) {
      response = star.bfDesignation;
    } else if (star.hdId.isNotEmpty) {
      response = 'HD ${star.hdId}';
    } else if (star.hrId.isNotEmpty) {
      response = 'HR ${star.hrId}';
    } else if (star.hipId.isNotEmpty) {
      response = 'HIP ${star.hipId}';
    } else if (star.glId.isNotEmpty) {
      response = '${star.glId}';
    }
    return response;
  }
}
