import 'dart:collection';
import 'dart:convert';
import 'package:star_sandwich/imports/request_keys.dart';
import 'package:star_sandwich/models/requests/get_geocoded_location_request.dart';
import 'package:star_sandwich/models/responses/result_status.dart';
import 'package:star_sandwich/models/responses/geocoded_location_response.dart';
import 'api_gateway.dart';

class LocationService {
  static final String getGeocodedLocationRoute = "getGeocodedLocation";

  static Future<ResultStatus<GeocodedLocationResponse>> getGeocodedLocation(
      String address) async {
    ResultStatus<GeocodedLocationResponse> retVal =
        new ResultStatus(success: false);

    Map<String, dynamic> jsonBody = new HashMap<String, dynamic>();
    jsonBody.putIfAbsent(RequestKeys.action, () => getGeocodedLocationRoute);
    jsonBody.putIfAbsent(RequestKeys.body,
        () => new GetGeocodedLocationRequest(address: address));

    try {
      ResultStatus<String> response = await makeApiRequest(jsonBody);
      if (response.success) {
        Map<String, dynamic> rawResponse = jsonDecode(response.data);
        retVal.success = true;
        retVal.data = new GeocodedLocationResponse.fromJson(rawResponse);
      } else if (response.networkError) {
        retVal.errorMessage = "Network error.Check internet connection.";
      } else {
        retVal.errorMessage = "Unable to get coordinates.";
      }
    } catch (e) {
      retVal.errorMessage = "Unable to get coordinates.";
    }

    return retVal;
  }
}
