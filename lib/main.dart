import 'package:flutter/material.dart';
import 'module/home/home_view.dart';
import 'injection/di.dart';

void main() {
  Injector.configure(Flavor.NETWORK);

  runApp(
    new MaterialApp(
      title: 'Figma Mirror',
      theme: new ThemeData(
        primarySwatch: Colors.blue
      ),
      home: new HomePage()
    )
  );
}
