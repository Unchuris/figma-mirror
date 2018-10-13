import 'dart:async';

import 'package:figma_mirror/data/entities/active_element.dart';
import 'package:figma_mirror/data/entities/fileResponse.dart';
import 'package:figma_mirror/data/repositories/screen_data.dart';

import '../../injection/di.dart';

abstract class ScreenListViewContract {
  void onLoadScreenComplete(String imageUrl, List<ActiveElement> items);
  void onLoadError(String error);
}

class ImageListPresenter {
  ScreenListViewContract _view;
  ScreenRepository _repository;
  FileResponse _baseJson;

  ImageListPresenter(this._view)  {
    _repository = new Injector().screenRepository;
  }

  loadScreen(String imageId) async {
    try {
      if (_baseJson == null) {
        await _loadFileAndExportPages();
      }
      if (imageId == null) {
        imageId = _getBaseImageIDFromBaseJson();
      }
      String _imageUrl = await _loadImageURL(imageId);
      List<ActiveElement> _items = _loadActiveElements(imageId);
      _view.onLoadScreenComplete(_imageUrl, _items);
    } on FetchDataException catch(e) {
      _view.onLoadError(e.toString());
    }
  }

  _loadFileAndExportPages() async {
    await _loadFile();
    _exportAllPages();
  }

  _loadFile() async {
    if (_view == null) return;
    _baseJson = await _repository.fetchFile();
  }

  _exportAllPages() {
    _repository.exportAllPages();
  }

  String _getBaseImageIDFromBaseJson() {
    return _baseJson.document.children.elementAt(0).prototypeStartNodeID;
  }

  Future<String> _loadImageURL(String imageId) {
    return _repository.fetchImageURL(imageId);
  }

  List<ActiveElement> _loadActiveElements(String imageId) {
    return _repository.getActiveElements(imageId);
  }

}