import 'package:cached_network_image/cached_network_image.dart';
import 'package:figma_mirror/data/entities/active_element.dart';
import 'package:flutter/material.dart';

import 'home_presenter.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new ImagePage()
      );
  }
}

class ImagePage extends StatefulWidget {
  ImagePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ImagePageState createState() => new _ImagePageState();
 }

 class _ImagePageState extends State<ImagePage> implements ScreenListViewContract {

  ImageListPresenter _presenter;

  String _imageUrl;

  List<ActiveElement> _activeElement = new List();

  String textUntilTheScreenIsLoaded = 'Loading...';

  bool _isLoading;

  _ImagePageState() {
    _presenter = new ImageListPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _presenter.loadScreen(null);
  }

  @override
  void onLoadScreenComplete(String imageUrl, List<ActiveElement> items) {
    setState(() {
      _imageUrl = imageUrl;
      _activeElement = items;
      _isLoading = false;
    });
  }

  @override
  void onLoadError(String e) {
    setState(() {
      textUntilTheScreenIsLoaded = "Load Failed.\n" + e;
    });
  }

  @override
  Widget build(BuildContext context) {

    var widget;

    if(_isLoading){
      widget = new Center(
        child: new Text(textUntilTheScreenIsLoaded)
      );
    } else {
      widget = new Scaffold(
        body: Stack(
          children: _drawElements(),
        ),
      );
    }

    return widget;
  }

  List<Widget> _drawElements() {

    var activeElement = <Widget>[new Center(
      child: CachedNetworkImage(
        placeholder: CircularProgressIndicator(),
        imageUrl: _imageUrl,
      )
    )];

    _activeElement.forEach( (item) => 
      activeElement.add(new Positioned(
        left: 65.0,
        top: item.y,
        child: new GestureDetector(
          onTap: () {
            _updateScreen(item.link);
          },
          child: new Container(
            width: item.width,
            height: item.height,
            decoration: new BoxDecoration(color: Colors.green),
          )
        ),
      ))
    );

    return activeElement;
  }

  _updateScreen(String imageId) {

    setState(() {
      _isLoading = true;
    });

    _presenter.loadScreen(imageId);
  }

 }
