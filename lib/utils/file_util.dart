import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileUtil {

  static Future<String> loadString(String fileName) async {
    Directory directory = await getApplicationDocumentsDirectory();
    File file = new File('${directory.path}/$fileName');
    return (file.existsSync()) ? await file.readAsString() : null;
  }

  static Future<void> saveString(String fileName, String data) async {
    Directory directory = await getApplicationDocumentsDirectory();
    File file = new File('${directory.path}/$fileName');
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
}
