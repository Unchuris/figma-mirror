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

  ImageListPresenter _presenter;

  String _imageUrl;

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
      widget = Center(
        child: _isError 
          ? Text(textUntilTheScreenIsLoaded)
          : CircularProgressIndicator()
      );
    } else {
      widget = Scaffold(
        body: Center(
          child: Container (
            child: LayoutBuilder(
              builder: (_, constraints) =>
                Container (
                  constraints: _getBoxFitContainSize(constraints),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(_imageUrl),
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
      );
    }

    return widget;
  }

 BoxConstraints _getBoxFitContainSize(BoxConstraints constraints) {

    Size size = Size(double.infinity, double.infinity);

    if (_activeElement.isNotEmpty) {

      double imageHeigth = _activeElement[0].parent.height;
      double imageWidth = _activeElement[0].parent.width;

      size = _getContainSize(
        Size(imageWidth, imageHeigth),
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

    double imageHeigth = _activeElement[0].parent.height;
    double imageWidth = _activeElement[0].parent.width;

    double heightFactor = constraints.maxHeight / imageHeigth;
    double widthFactor = constraints.maxWidth / imageWidth;
    
    _activeElement.forEach( (item) => 
      activeElement.add(Positioned(
        left: (item.x - item.parent.x).abs() * widthFactor,
        top: (item.y - item.parent.y).abs() * heightFactor,
        child: GestureDetector(
          onTap: () {
            _updateScreen(item.linkToNewImage);
          },
          child: Container(
            width: item.width * widthFactor,
            height: item.height * heightFactor,
            decoration: BoxDecoration(color: Colors.transparent,
            ),
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
