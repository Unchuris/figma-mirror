import 'dart:io';

import 'package:figma_mirror/data/repositories/file_name_utils.dart';
import 'package:path_provider/path_provider.dart';

class FileUtil {

  static Future<String> loadString(String token, String fileName) async {
    Directory directory = await getApplicationDocumentsDirectory();
    File file = new File('${directory.path}/$token$fileName');
    return (file.existsSync()) ? await file.readAsString() : null;
  }

  static Future<void> saveString(String token, String fileName, String data) async {
    Directory directory = await getApplicationDocumentsDirectory();
    File file = new File('${directory.path}/$token$fileName');
    await file.writeAsString(data);
    return new Future.value();
  }

  static Future<void> clear() async {
    Directory directory = await getApplicationDocumentsDirectory();
    directory.listSync().forEach((entity) {
      if (entity is File) {
        entity.deleteSync();
      }
    });
    return new Future.value();
  }

  static Future<bool> checkForExists(String token) async {
    Directory directory = await getApplicationDocumentsDirectory();
    File activeElement = File('${directory.path}/$token${FileNameUtils.activeElement}');
    File frameUrl = File('${directory.path}/$token${FileNameUtils.frameUrl}');
    File startNodeID = File('${directory.path}/$token${FileNameUtils.startNodeID}');
    return (await activeElement.exists() && await frameUrl.exists()
        && await startNodeID.exists());
  }
}
