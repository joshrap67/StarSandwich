import 'dart:collection';
import 'dart:convert';

import 'package:star_sandwich/imports/request_keys.dart';
import 'package:star_sandwich/models/requests/get_geocoded_location_request.dart';
import 'package:star_sandwich/models/responses/geocoded_location_response.dart';
import 'package:star_sandwich/models/responses/result_status.dart';

import 'api_gateway.dart';

class LocationService {
  static final String getGeocodedLocationRoute = 'getGeocodedLocation';

  static Future<ResultStatus<GeocodedLocationResponse>> getGeocodedLocation(String address) async {
    Map<String, dynamic> jsonBody = new HashMap<String, dynamic>();
    jsonBody.putIfAbsent(RequestKeys.action, () => getGeocodedLocationRoute);
    jsonBody.putIfAbsent(RequestKeys.body, () => new GetGeocodedLocationRequest(address: address));

    try {
      ResultStatus<String> response = await makeApiRequest(jsonBody);
      if (response.success()) {
        Map<String, dynamic> rawResponse = jsonDecode(response.data!);
        return ResultStatus.success(new GeocodedLocationResponse.fromJson(rawResponse));
      } else {
        return ResultStatus.failure('Unable to get coordinates.');
      }
    } catch (e) {
      return ResultStatus.failure('Unable to get coordinates.');
    }
  }
}
