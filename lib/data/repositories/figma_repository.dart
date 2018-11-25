import 'package:figma_mirror/data/datasource/remote/figma_base_api.dart';
import 'package:figma_mirror/data/entities/filesResponse.dart';
import 'package:figma_mirror/data/repositories/screen_data.dart';

class FigmaRepository implements HomeRepository {

  FigmaBaseApi _figmaApi;

  FigmaRepository(this._figmaApi);

  @override
  Future<FilesResponse> fetchAllFiles(String _token) async {
    return await _figmaApi.fetchFiles(_token).then((value) {
      return value;
    });
  }
}
