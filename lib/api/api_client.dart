import 'dart:convert';

import 'package:http/http.dart';
import 'package:movie_app/api/api_constants.dart';

// Reference
// https://www.youtube.com/watch?v=Pno5_POSk0E
class ApiClient {
  final Client _client;

  ApiClient(this._client);

  // Optional parameters
  dynamic get(String path, {Map<dynamic, dynamic>? params}) async {
    final response = await _client.get(
      Uri.parse(getPath(path, params)),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
  }

  String getPath(String path, Map<dynamic, dynamic>? params) {
    var paramsString = "";
    if (params != null && params.isNotEmpty) {
      params.forEach((key, value) {
        paramsString += '&$key=$value';
      });
    }

    return '${ApiConstants.BASE_URL}$path?api_key=${ApiConstants.API_Key}$paramsString';
  }
}
