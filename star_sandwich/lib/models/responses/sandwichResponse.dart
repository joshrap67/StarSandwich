import 'package:star_sandwich/models/responses/starResponse.dart';

class SandwichResponse {
  StarResponse starAbove;
  StarResponse starBelow;

  SandwichResponse.fromJson(Map<String, dynamic> json) {
    starAbove = new StarResponse.fromJson(json["starAbove"]);
    starBelow = new StarResponse.fromJson(json["starBelow"]);
  }

  @override
  String toString() {
    return "starAbove: ($starAbove) starBelow: ($starBelow)";
  }
}
