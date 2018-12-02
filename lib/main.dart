import 'package:figma_mirror/module/home/home_view.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(MaterialApp(
      title: 'Figma Mirror',
      theme: ThemeData(
          backgroundColor: Colors.white,
          canvasColor: Colors.white
      ),
      home: HomePage()));
}
