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

  String textUntilTheScreenIsLoaded;

  bool _isLoading, _isError;

  _ImagePageState() {
    _presenter = new ImageListPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _isError = false;
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
      _isError = true;
      textUntilTheScreenIsLoaded = "Load Failed.\n" + e;
    });
  }

  @override
  Widget build(BuildContext context) {

    var widget;

    if(_isLoading) {
      widget = new Center(
        child: _isError 
          ? Text(textUntilTheScreenIsLoaded)
          : CircularProgressIndicator()
      );
    } else {
      widget = new Scaffold(
        body: new Container (
          decoration: new BoxDecoration(
            image: new DecorationImage(
                image: new CachedNetworkImageProvider(_imageUrl),
                fit: BoxFit.fill
              )
            ),
          child: LayoutBuilder(
            builder: (context, constraints) =>
              new Stack(
                children: _drawElements(constraints)
              ),
          ),
      ));
    }

    return widget;
  }

  List<Widget> _drawElements(BoxConstraints constraints) {

    var activeElement = <Widget>[];

    if (_activeElement.isEmpty) return activeElement;

    double imageHeigth = _activeElement[0].parent.height;
    double imageWidth = _activeElement[0].parent.width;

    double heightFactor = constraints.maxHeight / imageHeigth;
    double widthFactor = constraints.maxWidth / imageWidth;
    
    _activeElement.forEach( (item) => 
      activeElement.add(new Positioned(
        left: (item.x - item.parent.x).abs() * widthFactor,
        top: (item.y - item.parent.y).abs() * heightFactor,
        child: new GestureDetector(
          onTap: () {
            _updateScreen(item.linkToNewImage);
          },
          child: new Container(
            width: item.width * widthFactor,
            height: item.height * heightFactor,
            decoration: new BoxDecoration(color: Colors.transparent),
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
