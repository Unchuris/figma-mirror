import 'dart:io';

import 'package:figma_mirror/data/repositories/file_name_utils.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'module/home/home_view.dart';
import 'injection/di.dart';

void main() async {
  Directory directory = await getApplicationDocumentsDirectory();
  File activeElement = new File('${directory.path}/${FileNameUtils.activeElement}');
  File frameUrl = new File('${directory.path}/${FileNameUtils.frameUrl}');
  File startNodeID = new File('${directory.path}/${FileNameUtils.startNodeID}');
  
  if (await activeElement.exists() && await frameUrl.exists() && await startNodeID.exists()) {
    Injector.configure(Flavor.LOCAL);
  } else {
    Injector.configure(Flavor.NETWORK);
  }

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
