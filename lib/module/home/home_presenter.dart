import 'package:figma_mirror/data/entities/filesResponse.dart';
import 'package:figma_mirror/data/repositories/screen_data.dart';
import 'package:figma_mirror/injection/di.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:figma_mirror/oAuth/flutter_auth.dart';
import 'package:figma_mirror/oAuth/model/config.dart';
import 'package:figma_mirror/oAuth/oauth.dart';
import 'package:figma_mirror/oAuth/token.dart';

abstract class HomeContract {
  void initListView(List<File> files);
}

class HomePresenter {
  FilesResponse _files;
  HomeRepository _repository;
  HomeContract _view;
  SharedPreferences _prefs;
  String _token;
  String _key = "TOKEN";
  Map<String, String> _customParameters = {
    "state": "file_read",
    "scope": "23134"
  };

  HomePresenter(this._view) {
    _repository = Injector().homeRepository;
  }

  void init() async {
    _prefs = await SharedPreferences.getInstance();
    if (_prefs.getString(_key) == null) {
      await _authorization();
    }
    _token = _prefs.getString(_key);
    await _loadAllProjects();
  }

  _loadAllProjects() async {
    _files = await _repository.fetchAllFiles(_token);
    _view.initListView(_files.meta.files);
  }

  _authorization() async {
    final OAuth flutterOAuth = FlutterOAuth(
      Config(
          "https://www.figma.com/oauth",
          "https://www.figma.com/api/oauth/token",
          "kZIYbxnxZ2emZnnxlhXx1M",
          "n7lJJ4mRZR9YtoAMk0xqdHH6WMwDBA",
          "http://localhost:8080",
          "code",
          parameters: _customParameters),
    );
    Token token = await flutterOAuth.performAuthorization();
    _prefs.setString(_key, token.accessToken);
  }
}
