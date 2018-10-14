import 'dart:async';
import 'dart:collection';

import 'package:figma_mirror/data/datasource/remote/figma_api.dart';
import 'package:figma_mirror/data/entities/active_element.dart';
import 'package:figma_mirror/data/entities/fileResponse.dart';
import 'package:figma_mirror/data/repositories/auth_repository.dart';
import 'package:figma_mirror/data/repositories/screen_data.dart';

class FigmaRepository implements ScreenRepository {

  final String _desiredItemType = "FRAME";

  FigmaAPI _figmaApi;

  AuthRepository _authRepository;

  FileResponse _baseJson;

  final HashMap<String, List<ActiveElement>> _activeElementMap = HashMap();

  final HashMap<String, Frame> _frameMap = HashMap();

  FigmaRepository(this._figmaApi, this._authRepository);

  Future<FileResponse> fetchFile() async {
    return await _figmaApi.fetchFile(
      _authRepository.getToken(), 
      _authRepository.getFileKey()
    ).then((value) {
      _baseJson = value;
      return _baseJson;
    });
  }

  Future<String> fetchImageUrl(String id) {
    return _figmaApi.fetchImageUrl(
      _authRepository.getToken(), 
      _authRepository.getFileKey(),
      id);
  }

  List<ActiveElement> getActiveElements(String frameId) {
    return _activeElementMap[frameId] == null ? List() : _activeElementMap[frameId];
  }

  exportAllFrames() async {
    if (_baseJson == null) {
      _baseJson = await fetchFile();
    }
    for (Frame data in _baseJson.document.children.elementAt(0).children) {
      if(data.id != null && data.type == _desiredItemType) {
        _frameMap.putIfAbsent(data.id, () => data);
        _activeElementMap.putIfAbsent(data.id, () => List<ActiveElement>());
        _addAllActiveChildrenToTheMap(data);
      } 
    }
  }

  _addAllActiveChildrenToTheMap(var frame) {
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

}