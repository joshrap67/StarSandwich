import 'request.dart';

class GetGeocodedLocationRequest extends Request {
  String? address;

  GetGeocodedLocationRequest({this.address});

  @override
  Map<String, dynamic> toJson() => {'address': address};
}
