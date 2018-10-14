import 'dart:async';
import 'dart:convert';

import 'package:figma_mirror/data/entities/fileResponse.dart';
import 'package:figma_mirror/data/repositories/screen_data.dart';

import 'package:http/http.dart';

class FigmaAPI {

  static const _baseURL = 'https://api.figma.com/v1';
  final BaseClient http;
  final int scale = 3;

  FigmaAPI(this.http);

  Future<FileResponse> fetchFile(String authToken, String fileKey) async {

    String url = "$_baseURL/files/$fileKey";

    return FileResponse.fromJson(
      json.decode(
        await _getHttpResponse(authToken, url)
        ));
  }
  
  Future<String> fetchImageUrl(String authToken, String fileKey, String id) async {
    
    String url = "$_baseURL/images/$fileKey?ids=$id&scale=$scale}";

    return json.decode(
        await _getHttpResponse(authToken, url)
      )['images'][id];
  }

  Future<String> _getHttpResponse(String authToken, String url) async {
    return await http.get(url,
      headers: {
        "X-FIGMA-TOKEN": authToken,
      })
      .then((Response response) {
        final String jsonBody = response.body;
        final statusCode = response.statusCode;
      
        if (jsonBody == null || statusCode > 200) {
          throw FetchDataException('HTTP request failed, statusCode: ${response?.statusCode}');
        }

        return jsonBody;
      });
  }

}