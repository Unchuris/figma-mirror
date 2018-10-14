import 'package:flutter/material.dart';
import 'module/home/home_view.dart';
import 'injection/di.dart';

void main() {
  Injector.configure(Flavor.NETWORK);

  runApp(
    MaterialApp(
      title: 'Figma Mirror',
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: HomePage()
    )
  );
}
