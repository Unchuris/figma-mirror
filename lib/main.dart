import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:figma_mirror/data/entities/fileResponse.dart';
import 'package:figma_mirror/figmaAPI.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Figma Mirror',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Figma Mirror'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final String authToken = "4077-7d63db95-dfc0-4f87-b546-d280ba9d5337";
  final String fileKey = "FVz0TcUD7ZwMAg6vz7D17l";
  var api;
  String imageUrl;
  String textUntilTheScreenIsLoaded = 'Loading...';

  _MyHomePageState() {
    _initPage();
  }

  _initPage() async {
    try {
      _initializeApi();
      FileResponse baseJson = await _getFileResponse();
      final imageID = _getBaseImageIDFromBaseJson(baseJson);
      dynamic responseImageAsJson = await _getImageResponseByID(imageID);
      final imgUrl = _getImageUrlFromJsonByID(responseImageAsJson, imageID);
      _drawImage(imgUrl);
    } on Exception catch(e) {
      _loadError(e);
    }
  }

  _initializeApi() {
    api = FigmaApi(Client(), authToken, fileKey);
  }

  Future<FileResponse> _getFileResponse() async  {
    String response = await api.getFile();
    return FileResponse.fromJson(json.decode(response));
  }

  String _getBaseImageIDFromBaseJson(FileResponse fileResponse) {
    return fileResponse.document.children
                .elementAt(0)
                .prototypeStartNodeID;
  }

  dynamic _getImageResponseByID(String id) async  {
    String response = await api.getImage(id);
    return json.decode(response);
  }

  String _getImageUrlFromJsonByID(dynamic responseAsJson, String imageID) {
    return responseAsJson['images'][imageID];
  }
  
  _drawImage(String imageUrl) async {
      setState(() {
        this.imageUrl = imageUrl;
      });
  }

  _loadError(e) {
    setState(() {
            textUntilTheScreenIsLoaded = "Load Failed.\n" + e.message;
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Center(
        child: imageUrl == null
            ? Text(textUntilTheScreenIsLoaded)
            : CachedNetworkImage(
                placeholder: CircularProgressIndicator(),
                imageUrl: imageUrl
            ),
      ),
    );
  }
}
