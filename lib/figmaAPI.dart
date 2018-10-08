import 'dart:async';

import 'package:http/http.dart';

class FigmaApi {
  final String authToken;
  final String fileKey;
  final BaseClient http;
  final int scale = 3;

  FigmaApi(this.http, this.authToken, this.fileKey);

  Future<String> getFile() async {
    String url = "https://api.figma.com/v1/files/$fileKey";
    return await _getHttpResponse(url);
  }
  
  Future<String> getImage(String id) async {
    String url = "https://api.figma.com/v1/images/$fileKey?ids=$id&scale=$scale}";
    return await _getHttpResponse(url);
  }

  Future<String> _getHttpResponse(String url) async {
    var response = await http.get(url,
        headers: {
          "X-FIGMA-TOKEN": this.authToken,
        });
        
    if (response == null || response.statusCode != 200) {
      throw new Exception('HTTP request failed, statusCode: ${response?.statusCode}');
    }

    return response.body;
  }

}