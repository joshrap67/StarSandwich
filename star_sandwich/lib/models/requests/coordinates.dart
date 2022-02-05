import 'package:star_sandwich/models/requests/request.dart';

class Coordinates extends Request {
  double? latitude;
  double? longitude;

  Coordinates({required this.longitude, required this.latitude});

  Coordinates.fromJson(Map<String, dynamic> rawResponse) {
    latitude = rawResponse['latitude'];
    longitude = rawResponse['longitude'];
  }

  @override
  String toString() {
    return 'Coordinates{Latitude: $latitude Longitude: $longitude}';
  }

  @override
  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
      };
}
