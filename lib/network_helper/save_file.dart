import 'dart:io';
import 'package:http/http.dart' show get;
import 'package:path_provider/path_provider.dart';

class SaveFile {
  Future<dynamic> localPath(String imageUrl) async {
    final response = await get(imageUrl);
    final documentDirectory = await getApplicationDocumentsDirectory();
    final  firstPath = documentDirectory.path + '/images';
    final filePathAndName = documentDirectory.path + '/images/pic.jpg';
    await Directory(firstPath).create(recursive: true);
    final File file = File(filePathAndName);
    file.writeAsBytesSync(response.bodyBytes);

    return file;
  }
}
