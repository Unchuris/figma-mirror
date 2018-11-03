import 'dart:collection';
import 'dart:convert';

import 'package:figma_mirror/data/entities/active_element.dart';
import 'package:figma_mirror/data/entities/fileResponse.dart';
import 'package:figma_mirror/data/repositories/file_name_utils.dart';
import 'package:figma_mirror/data/repositories/screen_data.dart';
import 'package:figma_mirror/utils/file_util.dart';

class LocalRepository implements ScreenRepository {

  HashMap<String, List<ActiveElement>> _activeElementMap = HashMap();

  HashMap<String, String> _frameUrlMap;

  String prototypeStartNodeID;

  LocalRepository();

  @override
  Future<void> exportAllFrames() async {
    prototypeStartNodeID = await FileUtil.loadString(FileNameUtils.startNodeID);
    String activeElement = await FileUtil.loadString(FileNameUtils.activeElement);
    HashMap<String, dynamic> parsedJson = HashMap<String, dynamic>.from(json.decode(activeElement));

    List<ActiveElement> activeElementList = List();
    parsedJson.forEach((key, value) {
      value.forEach((element) {
          ActiveElement el = ActiveElement.fromJson(element);
          activeElementList.add(el);
        }
      );
      _activeElementMap.putIfAbsent(key, () => activeElementList);
      activeElementList = List();
    });

    String frameUrl = await FileUtil.loadString(FileNameUtils.frameUrl);
    _frameUrlMap = HashMap<String, String>.from(json.decode(frameUrl));
  }

  @override
  Future<FileResponse> fetchFile() {
    return null;
  }

  @override
  List<ActiveElement> getActiveElements(String frameId) {
    return _activeElementMap[frameId] == null ? List() : _activeElementMap[frameId];
  }

  @override
  HashMap<String, String> getFrameUrlMap() {
    return _frameUrlMap;
  }

  @override
  String getPrototypeStartNodeID() {
    return prototypeStartNodeID;
  }
}
