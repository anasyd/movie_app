import 'dart:convert';

import 'package:http/http.dart';
import 'package:movie_app/api/api_constants.dart';

class ApiClient {
  final Client _client;

  ApiClient(this._client);

  dynamic get(String path) async {
    final response = await _client.get(
      Uri.parse(
          "${ApiConstants.BASE_URL}$path?api_key=${ApiConstants.API_Key}"),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
  }
}
