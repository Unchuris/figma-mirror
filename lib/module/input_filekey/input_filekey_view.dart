import 'package:figma_mirror/module/input_filekey/input_filekey_presenter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: FileKey());
  }
}

class FileKey extends StatefulWidget {
  @override
  FileKeyState createState() => FileKeyState();
}

class FileKeyState extends State<FileKey> implements InputFileKeyContract {
  String fileKey = "";
  InputFileKeyPresenter _presenter;
  final TextEditingController _controller = new TextEditingController();
  String _errorText = "";

  FileKeyState() {
    _presenter = InputFileKeyPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _presenter.init();
  }

  @override
  void initInputText(String text) {
    setState(() {
      _controller.text = text;
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
  void onLoadError(String error) {
    setState(() {
      _errorText = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [_textField(), Text(_errorText)])),
    );
  }

  _textField() {
    return TextField(
      textInputAction: TextInputAction.go,
      autofocus: true,
      decoration: InputDecoration(
        labelText: "File key",
      ),
      onSubmitted: (String str) {
        _presenter.onSubmitted(str);
      },
      controller: _controller,
    );
  }
}
