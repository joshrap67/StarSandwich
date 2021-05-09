import 'package:star_sandwich/models/requests/coordinates.dart';
import 'package:star_sandwich/models/requests/model.dart';

class MakeStarSandwichRequest extends Request {
  Coordinates coordinates;

  MakeStarSandwichRequest({this.coordinates});

  @override
  Map<String, dynamic> toJson() => {'coordinates': coordinates.toJson()};
}
