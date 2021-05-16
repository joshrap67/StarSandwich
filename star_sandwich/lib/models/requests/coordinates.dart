import 'package:star_sandwich/models/requests/model.dart';

class Coordinates extends Request {
  double latitude;
  double longitude;

  Coordinates({this.longitude, this.latitude});

  Coordinates.fromJson(Map<String, dynamic> rawResponse) {
    latitude = rawResponse["latitude"];
    longitude = rawResponse["longitude"];
  }

  @override
  String toString() {
    return "Latitude: $latitude Longitude: $longitude";
  }

  @override
  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
      };
}
