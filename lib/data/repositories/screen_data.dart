import 'dart:async';
import 'dart:collection';

import 'package:figma_mirror/data/entities/active_element.dart';
import 'package:figma_mirror/data/entities/fileResponse.dart';

abstract class ScreenRepository {
  Future<FileResponse> fetchFile();

  HashMap<String, String> getFrameUrlMap();

  List<ActiveElement> getActiveElements(String frameId);

  Future<void> exportAllFrames();

  String getPrototypeStartNodeID();
}

class FetchDataException implements Exception {
  String _message;

  FetchDataException(this._message);

  String toString() {
    return "$_message";
  }
}
