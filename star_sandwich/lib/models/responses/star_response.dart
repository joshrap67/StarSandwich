class StarResponse {
  String id;
  String hipId;
  String hdId;
  String hrId;
  String glId;
  String properName;
  String constellation;
  String iauConstellation;
  String bfDesignation;
  double rightAscension;
  double declination;
  int numStars;
  double magnitude;
  double distance;
  double absMagnitude;
  double luminosity;

  StarResponse.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    hipId = json["hipId"];
    hdId = json["hdId"];
    hrId = json["hrId"];
    glId = json["glId"];
    properName = json["properName"];
    constellation = json["constellation"];
	iauConstellation = json["iauConstellation"];
    bfDesignation = json["bfDesignation"];
    rightAscension = json["rightAscension"];
    declination = json["declination"];
    numStars = json["numStars"];
    magnitude = json["magnitude"].toDouble();
    distance = json["distance"].toDouble();
    absMagnitude = json["absMagnitude"].toDouble();
    luminosity = json["luminosity"].toDouble();
  }

  @override
  String toString() {
    return "Id: $id hipId: $hipId hdId: $hdId hrId: $hrId glId: $glId properName: $properName constellation: $constellation "
        " IAU Constellation: $iauConstellation bfDesignation: $bfDesignation rightAscension: $rightAscension declination: $declination numStars: $numStars"
        " magnitude: $magnitude distance: $distance absMagnitude: $absMagnitude luminosity: $luminosity";
  }
}
