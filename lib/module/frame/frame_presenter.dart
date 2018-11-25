import 'dart:async';
import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:figma_mirror/data/entities/active_element.dart';
import 'package:figma_mirror/data/entities/fileResponse.dart';
import 'package:figma_mirror/data/repositories/screen_data.dart';

import '../../injection/di.dart';

abstract class ScreenListViewContract {
  void cacheImages(List<String> imageUrl);
  void onLoadScreenComplete(
    CachedNetworkImageProvider frameUrl, 
    List<ActiveElement> items
  );
  void onLoadError(String error);
  void setVisibleStub(bool isVisible);
}

class ImageListPresenter {
  ScreenListViewContract _view;
  ScreenRepository _repository;
  FileResponse _baseJson;
  HashMap<String, String> _frameUrlMap = HashMap();
  HashMap<String, CachedNetworkImageProvider> _images = HashMap();

  ImageListPresenter(this._view)  {
    _repository = Injector().screenRepository;
  }

  loadAllScreen() async {
    try {
      if (_baseJson == null) {
        await _loadFileAndExportFrames();
      }
      _frameUrlMap = _repository.getFrameUrlMap();
      _cacheImages();
      var _frames = _frameUrlMap.keys.toList();
      for (var frameId in _frames) {
        var _items = _loadActiveElements(frameId);
        var _frame = _getImageProvider(frameId);
        if (_frame != null) {
          _view.onLoadScreenComplete(_frame, _items);
          await Future.delayed((Duration(seconds: 1)));
        }
      }
      loadScreen(_getBaseFrameIdFromBaseJson());
      _view.setVisibleStub(false);
    } on FetchDataException catch(e) {
      _view.onLoadError(e.toString());
    }
  }

  loadScreen(String frameId) async {
    try {
      var _frame = _getImageProvider(frameId);
      List<ActiveElement> _items = _loadActiveElements(frameId);
      if (_frame != null) {
        _view.onLoadScreenComplete(_frame, _items);
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
    return _repository.getPrototypeStartNodeID();
  }

  CachedNetworkImageProvider _getImageProvider(String frameId) {
    return _images[getImageUrl(frameId)];
  }

  String getImageUrl(String frameId) {
    return _frameUrlMap[frameId];
  }

  List<ActiveElement> _loadActiveElements(String frameId) {
    return _repository.getActiveElements(frameId);
  }

  void _cacheImages() {
    List<String> _imageUrl = _frameUrlMap.values.toList();
    _imageUrl.forEach( (imageUrl) => 
      _images.putIfAbsent(imageUrl, () => CachedNetworkImageProvider(imageUrl))
    );
  }
}
