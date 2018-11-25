import 'package:figma_mirror/data/entities/filesResponse.dart';
import 'package:figma_mirror/module/home/home_presenter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(body: Main());
  }
}

class Main extends StatefulWidget {
  @override
  MainState createState() => MainState();
}

class MainState extends State<Main> implements HomeContract {
  HomePresenter _presenter;
  List<File> _files;

  MainState() {
    _presenter = HomePresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _presenter.init();
  }

  @override
  void initListView(List<File> files) {
    setState(() {
      _files = files;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(_files.toString()));
  }
}
