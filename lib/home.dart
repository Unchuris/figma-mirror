import 'package:figma_mirror/oAuth/flutter_auth.dart';
import 'package:figma_mirror/oAuth/model/config.dart';
import 'package:figma_mirror/oAuth/oauth.dart';
import 'package:figma_mirror/oAuth/token.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthorizationView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
        body: Main()
      );
  }
}

class Main extends StatefulWidget {
  @override
  MainState createState() => MainState();
}

class MainState extends State<Main> {

  Map<String, String> customParameters = {"state": "file_read", "scope": "23134"};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Center(
                child: RaisedButton(
                  child: Text("Authorization"),
                  onPressed: () => authorization(),
                )
            ),
          ),
        ],
      ),
    );
  }

  authorization() async {
    final OAuth flutterOAuth = FlutterOAuth(Config(
        "https://www.figma.com/oauth",
        "https://www.figma.com/api/oauth/token",
        "kZIYbxnxZ2emZnnxlhXx1M",
        "n7lJJ4mRZR9YtoAMk0xqdHH6WMwDBA",
        "http://localhost:8080",
        "code",
        parameters: customParameters),
    );
    Token token = await flutterOAuth.performAuthorization();
    var alert = AlertDialog(
      title: Text("Access Token"),
      content: Text(token.accessToken),
    );
    showDialog(context: context, builder: (_) => alert);
  }
}
