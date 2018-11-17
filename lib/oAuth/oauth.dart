import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:figma_mirror/oAuth/auth_code_information.dart';
import 'package:figma_mirror/oAuth/model/config.dart';
import 'package:figma_mirror/oAuth/oauth_token.dart';
import 'package:figma_mirror/oAuth/token.dart';
import 'package:http/http.dart';

abstract class OAuth {

  final Config configuration;
  final AuthorizationRequest requestDetails;
  String code;
  Map<String, dynamic> token;

  TokenRequestDetails tokenRequest;

  OAuth(this.configuration, this.requestDetails);

  Future<Map<String, dynamic>> getToken() async {
    if (token == null) {
      Response response = await post("${tokenRequest.url}",
          body: json.encode(tokenRequest.params),
          headers: tokenRequest.headers);
      token = json.decode(response.body);
    }
    return token;
  }

  bool shouldRequestCode() => code == null;

  String constructUrlParams() => mapToQueryParams(requestDetails.parameters);

  String mapToQueryParams(Map<String, String> params) {
    final queryParams = <String>[];
    params.forEach((String key, String value) => queryParams.add("$key=$value"));
    return queryParams.join("&");
  }

  void generateTokenRequest() {
    tokenRequest = TokenRequestDetails(configuration, code);
  }

  Future<Token> performAuthorization() async {
    String resultCode = await requestCode();
    if (resultCode != null) {
      generateTokenRequest();
      return Token.fromJson(await getToken());
    }
    return null;
  }

  Future<String> requestCode();
}
