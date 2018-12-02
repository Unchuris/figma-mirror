import 'package:figma_mirror/data/entities/filesResponse.dart';
import 'package:figma_mirror/module/home/home_presenter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Center(
        child: getHomePageBody(context),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Item',
        child: Icon(Icons.add),
        onPressed: () => _openDialog(context),
      ),
    );
  }

  getHomePageBody(BuildContext context) {
    return (_files.length < 1)
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/EmptyList.png",
                width: 240,
                height: 240,
              ),
              Text(
                "It seems you haven't added any files yet.\n"
                    "You need to add a new file key. \n"
                    "The file key can be parsed from any Figma file url: \n"
                    "https://www.figma.com/file/:key/:title",
                textAlign: TextAlign.center,
              )
            ],
          )
        : ListView.builder(
            itemCount: _files.length,
            itemBuilder: _getItemUI,
            padding: EdgeInsets.all(0.0),
          );
  }

  Widget _getItemUI(BuildContext context, int index) {
    return Text(_files[index].name);
  }

  _openDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("Add new file key"),
              content: TextField(
                autofocus: true,
                decoration: InputDecoration(
                  labelText: "File key",
                ),
                onSubmitted: (String str) {
                  setState(() {
                    _controller.text = "";
                  });
                  _presenter.onSubmitted(str);
                },
                controller: _controller,
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("CANCEL"),
                  onPressed: () => Navigator.pop(context),
                ),
                FlatButton(
                  child: Text("OK"),
                  onPressed: () => _presenter.onSubmitted(_controller.text),
                )
              ],
            ));
  }
}
