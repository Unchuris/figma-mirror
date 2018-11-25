import 'dart:convert';

import 'package:figma_mirror/data/entities/filesResponse.dart';
import 'package:figma_mirror/data/repositories/screen_data.dart';
import 'package:http/http.dart';

class FigmaBaseApi {
  static const _baseURL = 'https://figma.com/api';
  final BaseClient http;

  FigmaBaseApi(this.http);

  Future<FilesResponse> fetchFiles(String authToken) async {
    String url = "$_baseURL/user/state";

    return FilesResponse.fromJson(
        json.decode(await _getHttpResponse(authToken, url)));
  }

  Future<String> _getHttpResponse(String authToken, String url) async {
    return await http.get(url, headers: {
      "Authorization": "Bearer $authToken",
    }).then((Response response) {
      final String jsonBody = response.body;
      final statusCode = response.statusCode;

      if (jsonBody == null || statusCode > 200) {
        throw FetchDataException(
            'HTTP request failed, statusCode: ${response?.statusCode}');
      }

      return jsonBody;
    });
  }
}
