import 'package:star_sandwich/models/responses/star_response.dart';

class SandwichResponse {
  StarResponse? starAbove;
  StarResponse? starBelow;

  SandwichResponse.fromJson(Map<String, dynamic> json) {
    starAbove = json['starAbove'] != null ? new StarResponse.fromJson(json['starAbove']) : null;
    starBelow = json['starBelow'] != null ? new StarResponse.fromJson(json['starBelow']) : null;
  }

  @override
  String toString() {
    return 'SandwichResponse{starAbove: $starAbove, starBelow: $starBelow}';
  }
}
