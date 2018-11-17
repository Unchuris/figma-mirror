class Token {

  String accessToken;

  Token();

  factory Token.fromJson(Map<String, dynamic> json) => Token.fromMap(json);

  Map toMap() => Token.toJsonMap(this);

  @override
  String toString() => Token.toJsonMap(this).toString();

  static Map toJsonMap(Token model) {
    Map map = Map();
    if (model != null && model.accessToken != null) {
      map["access_token"] = model.accessToken;
    }
    return map;
  }

  static Token fromMap(Map map) {
    if (map == null) return null;
    Token model = Token();
    model.accessToken = map["access_token"] as String;
    return model;
  }
}
