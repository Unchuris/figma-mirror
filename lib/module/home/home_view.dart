import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:figma_mirror/data/entities/active_element.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home_presenter.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
        body: ImagePage()
      );
  }
}

class ImagePage extends StatefulWidget {
  ImagePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ImagePageState createState() => _ImagePageState();
 }

 class _ImagePageState extends State<ImagePage> implements ScreenListViewContract {

  Timer _timer;

  ImageListPresenter _presenter;

  CachedNetworkImageProvider _image;

  var _backgroundColor = Colors.transparent;

  List<ActiveElement> _activeElement = List();

  String textUntilTheScreenIsLoaded;

  bool _isLoading, _isError;

  _ImagePageState() {
    _presenter = ImageListPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _isError = false;
    _presenter.loadAllScreen();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void onLoadScreenComplete(CachedNetworkImageProvider image, List<ActiveElement> items) {
    setState(() {
      _image = image;
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
  void cacheImages(List<String> _imageUrl) {
    _imageUrl.forEach( (imageUrl) => 
      CachedNetworkImageProvider(imageUrl)
    );
  }

  @override
  Widget build(BuildContext context) {

    var widget;

    if(_isLoading) {
      widget = Center(
        child: _isError 
          ? Text(textUntilTheScreenIsLoaded)
          : CircularProgressIndicator()
      );
    } else {
      widget = Scaffold(
        body: Center(
          child: GestureDetector(
            onTap: () {
              _highlightActiveElements();
            },
            child: Container (
              child: LayoutBuilder(
                builder: (_, constraints) =>
                  Container (
                    constraints: _getBoxFitContainSize(constraints),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: _image,
                        fit: BoxFit.fill,
                      )
                    ),
                    child: LayoutBuilder(
                      builder: (_, constraints) =>
                        Stack(
                          children: _drawElements(constraints)
                        )
                    )
                  )
              )
            )
          )
        )
      );
    }

    return widget;
  }

 _highlightActiveElements() {
   setState(() {
      _backgroundColor = Colors.blueAccent.withOpacity(0.5);
    });
    _timer = Timer(Duration(seconds: 1), () {
        setState(() {
          _backgroundColor = Colors.transparent;
        });
    });
 }

 BoxConstraints _getBoxFitContainSize(BoxConstraints constraints) {

    Size size = Size(double.infinity, double.infinity);

    if (_activeElement.isNotEmpty) {

      double frameHeigth = _activeElement[0].parent.absoluteBoundingBox.height;
      double frameWidth = _activeElement[0].parent.absoluteBoundingBox.width;

      size = _getContainSize(
        Size(frameWidth, frameHeigth),
        Size(constraints.maxWidth, constraints.maxHeight)
      );
    }
    
    return BoxConstraints.expand(
      height: size.height,
      width: size.width,
    );
  }

  Size _getContainSize(Size sourceSize, Size destinationSize) {
    if (sourceSize.height <= 0.0 || sourceSize.width <= 0.0 || destinationSize.height <= 0.0 || destinationSize.width <= 0.0)
      return Size(double.infinity, double.infinity);

    return destinationSize.width / destinationSize.height > sourceSize.width / sourceSize.height 
      ? Size(sourceSize.width * destinationSize.height / sourceSize.height, destinationSize.height)
      : Size(destinationSize.width, sourceSize.height * destinationSize.width / sourceSize.width);
  }

  List<Widget> _drawElements(BoxConstraints constraints) {

    var activeElement = <Widget>[];

    if (_activeElement.isEmpty) return activeElement;

    double frameHeigth = _activeElement[0].parent.absoluteBoundingBox.height;
    double frameWidth = _activeElement[0].parent.absoluteBoundingBox.width;

    double heightFactor = constraints.maxHeight / frameHeigth;
    double widthFactor = constraints.maxWidth / frameWidth;
    
    _activeElement.forEach( (item) => 
      activeElement.add(Positioned(
        left: (item.x - item.parent.absoluteBoundingBox.x).abs() * widthFactor,
        top: (item.y - item.parent.absoluteBoundingBox.y).abs() * heightFactor,
        child: GestureDetector(
          onTap: () {
            _updateScreen(item.linkToNewFrame);
          },
          child: Container(
            width: item.width * widthFactor,
            height: item.height * heightFactor,
            decoration: BoxDecoration(color: _backgroundColor,
            ),
          )
        ),
      ))
    );

    return activeElement;
  }

  _updateScreen(String frameId) {
    _presenter.loadScreen(frameId);
  }
}
