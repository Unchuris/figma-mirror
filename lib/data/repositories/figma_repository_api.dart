import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:figma_mirror/data/datasource/remote/figma_api.dart';
import 'package:figma_mirror/data/entities/active_element.dart';
import 'package:figma_mirror/data/entities/fileResponse.dart';
import 'package:figma_mirror/data/repositories/auth_repository.dart';
import 'package:figma_mirror/data/repositories/file_name_utils.dart';
import 'package:figma_mirror/data/repositories/screen_data.dart';
import 'package:figma_mirror/utils/file_util.dart';

class FigmaRepositoryApi implements ScreenRepository {
  final String _desiredItemType = "FRAME";

  FigmaAPI _figmaApi;

  AuthRepository _authRepository;

  FileResponse _baseJson;

  final HashMap<String, List<ActiveElement>> _activeElementMap = HashMap();

  final HashMap<String, Frame> _frameMap = HashMap();

  final HashMap<String, String> _frameUrlMap = HashMap();

  String prototypeStartNodeID;

  FigmaRepositoryApi(this._figmaApi, this._authRepository);

  Future<FileResponse> fetchFile() async {
    return await _figmaApi
        .fetchFile(_authRepository.getToken(), _authRepository.getFileKey())
        .then((value) {
      _baseJson = value;
      prototypeStartNodeID =
          _baseJson.document.children.elementAt(0).prototypeStartNodeID;
      return _baseJson;
    });
  }

  HashMap<String, String> getFrameUrlMap() {
    return _frameUrlMap;
  }

  List<ActiveElement> getActiveElements(String frameId) {
    return _activeElementMap[frameId] == null
        ? List()
        : _activeElementMap[frameId];
  }

  Future<void> exportAllFrames() async {
    if (_baseJson == null) {
      _baseJson = await fetchFile();
    }
    for (Frame data in _baseJson.document.children.elementAt(0).children) {
      String id = data.id;
      if (id != null && data.type == _desiredItemType) {
        _frameMap.putIfAbsent(id, () => data);
        await _loadFrameUrlAndPutMap(id);
        _activeElementMap.putIfAbsent(id, () => List<ActiveElement>());
        _addAllActiveChildrenToMap(data);
      }
    }
    _saveData();
    return;
  }

  _loadFrameUrlAndPutMap(String frameId) async {
    String frameUrl = await _fetchImageUrl(frameId);
    _frameUrlMap.putIfAbsent(frameId, () => frameUrl);
  }

  Future<String> _fetchImageUrl(String id) async {
    return await _figmaApi.fetchImageUrl(
      _authRepository.getToken(),
      _authRepository.getFileKey(),
      id,
    );
  }

  _addAllActiveChildrenToMap(var frame) {
    for (var frameData in frame.children) {
      _setChildrenInMap(frameData.children, frame.id);
    }
  }

  _setChildrenInMap(List<Element> children, String id) {
    if (children == null || children.isEmpty) return;

    for (Element c in children) {
      if (c.transitionNodeID == null) {
        if (c.children != null) {
          _setChildrenInMap(c.children, id);
        }
      } else {
        ActiveElement activeElement = ActiveElement(
            c.absoluteBoundingBox.x,
            c.absoluteBoundingBox.y,
            c.absoluteBoundingBox.width,
            c.absoluteBoundingBox.height,
            c.transitionNodeID,
            _frameMap[id]);
        _activeElementMap[id].add(activeElement);
      }
    }
  }

  String getPrototypeStartNodeID() {
    return prototypeStartNodeID;
  }

  void _saveData() {
    var fileKey = _authRepository.getFileKey();
    FileUtil.saveString(
        fileKey, FileNameUtils.startNodeID, prototypeStartNodeID);
    FileUtil.saveString(
        fileKey, FileNameUtils.frameUrl, json.encode(_frameUrlMap));
    FileUtil.saveString(
        fileKey, FileNameUtils.activeElement, json.encode(_activeElementMap));
  }
}
