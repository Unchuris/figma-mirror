import 'dart:async';
import 'dart:collection';

import 'package:figma_mirror/data/datasource/remote/figma_api.dart';
import 'package:figma_mirror/data/entities/active_element.dart';
import 'package:figma_mirror/data/entities/fileResponse.dart';
import 'package:figma_mirror/data/entities/image.dart';
import 'package:figma_mirror/data/repositories/auth_repository.dart';
import 'package:figma_mirror/data/repositories/screen_data.dart';

class FigmaRepository implements ScreenRepository {

  final String _desiredItemType = "FRAME";

  FigmaAPI _figmaApi;

  AuthRepository _authRepository;

  FileResponse _baseJson;

  final HashMap<String, List<ActiveElement>> _map = new HashMap();

  final HashMap<String, MyImage> _imageMap = new HashMap();

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

  Future<String> fetchImageURL(String id) {
    return _figmaApi.fetchImageURL(
      _authRepository.getToken(), 
      _authRepository.getFileKey(),
      id);
  }

  List<ActiveElement> getActiveElements(String pageID) {
    return _map[pageID] == null ? new List() : _map[pageID];
  }

  exportAllPages() async {
    if (_baseJson == null) {
      _baseJson = await fetchFile();
    }
    for (Frame data in _baseJson.document.children.elementAt(0).children) {
      if(data.id != null && data.type == _desiredItemType) {
        _addImageToTheImageMap(data);
        _map.putIfAbsent(data.id, () => new List<ActiveElement>());
        _addAllActiveChildrenToTheMap(data);
      } 
    }
  }

  _addImageToTheImageMap(Frame data) {
    MyImage img = new MyImage(
      data.id,
      data.absoluteBoundingBox.x,
      data.absoluteBoundingBox.y,
      data.absoluteBoundingBox.width,
      data.absoluteBoundingBox.height,
    );
    _imageMap.putIfAbsent(data.id, () => img);
  }

  _addAllActiveChildrenToTheMap(var pageData) {
    for (var frameData in pageData.children) {
      _setChildrenInMap(frameData.children, pageData.id);
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
        ActiveElement activeElement = new ActiveElement(
          c.absoluteBoundingBox.x,
          c.absoluteBoundingBox.y,
          c.absoluteBoundingBox.width, 
          c.absoluteBoundingBox.height, 
          c.transitionNodeID, 
          _imageMap[id]);
        _map[id].add(activeElement);
      }
    }
  }

}