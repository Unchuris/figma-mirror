import 'package:figma_mirror/data/entities/filesResponse.dart';
import 'package:figma_mirror/module/home/home_presenter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Main());
  }
}

class Main extends StatefulWidget {
  @override
  MainState createState() => MainState();
}

class MainState extends State<Main> implements HomeContract {
  HomePresenter _presenter;
  List<File> _files = List();
  final TextEditingController _controller = new TextEditingController();

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
  void openScreen(Object screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              decoration: new InputDecoration(hintText: "Enter text here..."),
              onSubmitted: (String str) {
                setState(() {
                  _controller.text = "";
                });
                _presenter.onSubmitted(str);
              },
              controller: _controller,
            ),
          ],
        ),
      ),
    );
  }

  getHomePageBody(BuildContext context) {
    return ListView.builder(
      itemCount: _files.length,
      itemBuilder: _getItemUI,
      padding: EdgeInsets.all(0.0),
    );
  }

  Widget _getItemUI(BuildContext context, int index) {
    return Text(_files[index].name);
  }
}
