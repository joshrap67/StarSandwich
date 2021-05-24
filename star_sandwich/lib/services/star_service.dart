import 'dart:collection';
import 'dart:convert';
import 'package:star_sandwich/imports/request_keys.dart';
import 'package:star_sandwich/models/requests/coordinates.dart';
import 'package:star_sandwich/models/requests/make_star_sandwich_request.dart';
import 'package:star_sandwich/models/responses/result_status.dart';
import 'package:star_sandwich/models/responses/sandwich_response.dart';
import 'api_gateway.dart';

class StarService {
  static final String makeStarSandwichRoute = 'makeStarSandwich';

  static Future<ResultStatus<SandwichResponse>> makeStarSandwich(
      double latitude, double longitude) async {
    ResultStatus<SandwichResponse> retVal = new ResultStatus(success: false);

    Map<String, dynamic> jsonBody = new HashMap<String, dynamic>();
    jsonBody.putIfAbsent(RequestKeys.action, () => makeStarSandwichRoute);
    jsonBody.putIfAbsent(
        RequestKeys.body,
        () => new MakeStarSandwichRequest(
            coordinates:
                new Coordinates(latitude: latitude, longitude: longitude)));

    try {
      ResultStatus<String> response = await makeApiRequest(jsonBody);
      if (response.success) {
        Map<String, dynamic> rawResponse = jsonDecode(response.data);
        retVal.success = true;
        retVal.data = new SandwichResponse.fromJson(rawResponse);
      } else if (response.networkError) {
        retVal.errorMessage = 'Network error.Check internet connection.';
      } else {
        retVal.errorMessage = 'Unable to get sandwich.';
      }
    } catch (e) {
      retVal.errorMessage = 'Unable to make sandwich.';
    }

    return retVal;
  }
}
