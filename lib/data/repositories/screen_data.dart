import 'dart:async';
import 'dart:collection';

import 'package:figma_mirror/data/entities/active_element.dart';
import 'package:figma_mirror/data/entities/fileResponse.dart';
import 'package:figma_mirror/data/entities/filesResponse.dart';

abstract class ScreenRepository {
  Future<FileResponse> fetchFile();

  HashMap<String, String> getFrameUrlMap();

  List<ActiveElement> getActiveElements(String frameId);

  Future<void> exportAllFrames();

  String getPrototypeStartNodeID();
}

abstract class HomeRepository {
  Future<FilesResponse> fetchAllFiles(String _token);
}

class FetchDataException implements Exception {
  String _message;

  FetchDataException(this._message);

  String toString() {
    return "$_message";
  }
}
