import 'package:figma_mirror/module/input_filekey/input_filekey_view.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(MaterialApp(
      title: 'Figma Mirror',
      theme: ThemeData(
          backgroundColor: Colors.white,
          canvasColor: Colors.white
      ),
      home: InputPage()));
}
