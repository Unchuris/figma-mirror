import 'package:figma_mirror/data/entities/filesResponse.dart';
import 'package:figma_mirror/data/repositories/auth_repository.dart';
import 'package:figma_mirror/injection/di.dart';
import 'package:figma_mirror/module/frame/frame_view.dart';
import 'package:figma_mirror/utils/file_util.dart';
import 'package:figma_mirror/data/repositories/screen_data.dart';

abstract class InputFileKeyContract {

  void openScreen(Object screen);

  void onLoadError(String error);
}
class InputFileKeyPresenter {
  FilesResponse _files;
  ScreenRepository _repository;
  String _token = "5738-bfd8dbf1-4fb1-4886-a5f4-c4e71ba15a76";
  InputFileKeyContract _view;

  InputFileKeyPresenter(this._view);

  onSubmitted(String str) async {
    var auth = AuthRepository(_token, str);
    if (await FileUtil.checkForExists(str)) {
      Injector.configure(Flavor.LOCAL, auth);
      _view.openScreen(FramePage());
    } else {
      Injector.configure(Flavor.NETWORK, auth);
      _repository = Injector().screenRepository;
      if (await _checkKey(str)) {
        _view.openScreen(FramePage());
      }
    }
  }

  Future<bool> _checkKey(String str) async {
    try {
      await _repository.fetchFile();
      return true;
    } on FetchDataException catch(e) {
      _view.onLoadError(e.toString());
      return false;
    }
  }
}
