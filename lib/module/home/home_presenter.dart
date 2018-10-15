import 'package:figma_mirror/data/entities/active_element.dart';
import 'package:figma_mirror/data/entities/fileResponse.dart';
import 'package:figma_mirror/data/repositories/screen_data.dart';

import '../../injection/di.dart';

abstract class ScreenListViewContract {
  void onLoadScreenComplete(String frameUrl, List<ActiveElement> items);
  void onLoadError(String error);
}

class ImageListPresenter {
  ScreenListViewContract _view;
  ScreenRepository _repository;
  FileResponse _baseJson;

  ImageListPresenter(this._view)  {
    _repository = Injector().screenRepository;
  }

  loadScreen(String frameId) async {
    try {
      if (_baseJson == null) {
        await _loadFileAndExportFrames();
      }
      if (frameId == null) {
        frameId = _getBaseFrameIdFromBaseJson();
      }
      String _frameUrl = _getFrameUrl(frameId);
      List<ActiveElement> _items = _loadActiveElements(frameId);
      if (_frameUrl != null && _items.isNotEmpty) {
        _view.onLoadScreenComplete(_frameUrl, _items);
      }
    } on FetchDataException catch(e) {
      _view.onLoadError(e.toString());
    }
  }

  _loadFileAndExportFrames() async {
    await _loadFile();
    await _exportAllFrames();
  }

  _loadFile() async {
    if (_view == null) return;
    _baseJson = await _repository.fetchFile();
  }

  _exportAllFrames() async {
     await _repository.exportAllFrames();
  }

  String _getBaseFrameIdFromBaseJson() {
    return _baseJson.document.children.elementAt(0).prototypeStartNodeID;
  }

  String _getFrameUrl(String frameId) {
    return _repository.getImageUrl(frameId);
  }

  List<ActiveElement> _loadActiveElements(String frameId) {
    return _repository.getActiveElements(frameId);
  }

}