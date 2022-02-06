import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:star_sandwich/imports/request_keys.dart';
import 'package:star_sandwich/models/responses/result_status.dart';

import '../imports/config.dart';

Future<ResultStatus<String>> makeApiRequest(Map<String, dynamic> requestContent) async {
  try {
    var url = Uri.parse(Config.apiRootUrl + requestContent[RequestKeys.action]);
    http.Response response = await http.post(url, body: json.encode(requestContent[RequestKeys.body]));
    if (response.statusCode == 200) {
      return ResultStatus.success(response.body);
    } else {
      return ResultStatus.failure(response.body);
    }
  } on SocketException catch (_) {
    return ResultStatus.success('Error connecting to server.');
  }
}
