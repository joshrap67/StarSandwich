import 'package:star_sandwich/models/requests/model.dart';

class Coordinates extends Request {
  double latitude;
  double longitude;

  Coordinates({this.longitude, this.latitude});

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
