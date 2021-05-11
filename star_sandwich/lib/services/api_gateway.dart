import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:star_sandwich/imports/RequestKeys.dart';
import 'package:star_sandwich/models/responses/resultStatus.dart';

import '../config.dart';

Future<ResultStatus<String>> makeApiRequest(
    Map<String, dynamic> requestContent) async {
  ResultStatus<String> retVal =
      new ResultStatus(success: false, networkError: false);

  try {
    var url = Uri.parse(Config.apiRootUrl + requestContent[RequestKeys.action]);
    http.Response response = await http.post(url,
        body: json.encode(requestContent[RequestKeys.body]));
    if (response.statusCode == 200) {
      retVal.success = true;
      retVal.data = response.body;
    } else {
      retVal.success = false;
      print(response.body);
      retVal.data = response.body;
    }
  } on SocketException catch (_) {
    retVal.networkError = true;
  }
  return retVal;
}
