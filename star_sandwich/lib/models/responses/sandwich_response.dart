import 'package:star_sandwich/models/responses/star_response.dart';

class SandwichResponse {
  StarResponse starAbove;
  StarResponse starBelow;

  SandwichResponse.fromJson(Map<String, dynamic> json) {
    // todo handle nulls
    starAbove = new StarResponse.fromJson(json["starAbove"]);
    starBelow = new StarResponse.fromJson(json["starBelow"]);
  }

  @override
  String toString() {
    return "starAbove: ($starAbove) starBelow: ($starBelow)";
  }
}
