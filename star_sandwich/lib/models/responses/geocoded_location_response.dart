import 'package:star_sandwich/models/requests/coordinates.dart';

class GeocodedLocationResponse {
  Coordinates coordinates;
  String formattedAddress;

  GeocodedLocationResponse.fromJson(Map<String, dynamic> rawResponse) {
    coordinates = new Coordinates.fromJson(rawResponse["coordinates"]);
    formattedAddress = rawResponse["formattedAddress"];
  }
}
