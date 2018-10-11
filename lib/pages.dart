import 'dart:collection';

import 'package:figma_mirror/activeElement.dart';
import 'package:figma_mirror/data/entities/fileResponse.dart';


class FigmaPage {
  FileResponse _baseJson;
  List<ActiveElement> activeElements;

  final HashMap<String, List<ActiveElement>> _map = new HashMap();

  FigmaPage(FileResponse fileResponse) {
    _baseJson = fileResponse;
  }

  exportAllPages() {
    for (var data in _baseJson.document.children.elementAt(0).children) {
      if(data.id != null) {
        _map.putIfAbsent(data.id, () => new List<ActiveElement>());
        _addAllActiveChildrenToTheMap(data);
      } 
    }
  }

  _addAllActiveChildrenToTheMap(var pageData) {
    for (var frameData in pageData.children) {
      if (frameData.type != "FRAME") {
        continue;
      }
      _setChildrenInMap(frameData.children, pageData.id);
    }
  }

  _setChildrenInMap(var children, String id) {
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
          "");
        _map[id].add(activeElement);
      }
    }
  }

  List<ActiveElement> getActiveElements(String pageID) {
    return _map[pageID] == null ? new List() : _map[pageID];
  }

}