import 'package:figma_mirror/data/repositories/auth_repository.dart';
import 'package:figma_mirror/injection/di.dart';
import 'package:figma_mirror/module/frame/frame_view.dart';
import 'package:figma_mirror/utils/file_util.dart';
import 'package:figma_mirror/data/repositories/screen_data.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';

abstract class InputFileKeyContract {

  void initInputText(String text);

  void openScreen(Object screen);

  void onLoadError(String error);
}

class InputFileKeyPresenter {
  static const platform = const MethodChannel('app.channel.shared.data');
  SharedPreferences _prefs;
  ScreenRepository _repository;
  String _token = "5738-bfd8dbf1-4fb1-4886-a5f4-c4e71ba15a76";
  InputFileKeyContract _view;
  String _key = "FILEKEY";

  InputFileKeyPresenter(this._view);

  void init() async {
    _prefs = await SharedPreferences.getInstance();
    String fileKey = await _getSharedText();
    if (fileKey == null) {
      fileKey = _prefs.getString(_key);
    }
    _view.initInputText(fileKey);
  }

  Future<String> _getSharedText() async {
    try {
      Uri initialUri = await getInitialUri();
      if (initialUri != null && initialUri.pathSegments.length > 1) {
        return initialUri.pathSegments[1];
      } else {
        return null;
      }
    } on FormatException {
      return null;
    }
  }

  onSubmitted(String str) async {
    var auth = AuthRepository(_token, str);
    if (await FileUtil.checkForExists(str)) {
      Injector.configure(Flavor.LOCAL, auth);
      _nextScreen(str);
    } else {
      Injector.configure(Flavor.NETWORK, auth);
      _repository = Injector().screenRepository;
      if (await _checkKey(str)) {
        _nextScreen(str);
      }
    }
  }

  Future<bool> _checkKey(String str) async {
    try {
      await _repository.fetchFile();
      return true;
    } on FetchDataException catch (e) {
      _view.onLoadError(e.toString());
      return false;
    }
  }

  _nextScreen(String fileKey) async {
    await _prefs.setString(_key, fileKey);
    _view.openScreen(FramePage());
  }
}
