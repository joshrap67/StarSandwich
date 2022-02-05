import 'package:star_sandwich/models/requests/coordinates.dart';
import 'package:star_sandwich/models/requests/request.dart';

class MakeStarSandwichRequest extends Request {
  Coordinates coordinates;

  MakeStarSandwichRequest({required this.coordinates});

  @override
  Map<String, dynamic> toJson() => {'coordinates': coordinates.toJson()};
}
