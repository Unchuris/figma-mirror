import 'dart:async';

import 'package:figma_mirror/data/entities/active_element.dart';
import 'package:figma_mirror/data/entities/fileResponse.dart';

abstract class ScreenRepository {
  Future<FileResponse> fetchFile();

  Future<String> fetchImageUrl(String id);

  List<ActiveElement> getActiveElements(String frameId);

  void exportAllFrames();
}

class FetchDataException implements Exception {
  String _message;

  FetchDataException(this._message);

  String toString() {
    return "$_message";
  }

}
