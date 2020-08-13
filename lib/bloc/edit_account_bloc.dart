import 'dart:io';
import 'dart:math' as math;
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

import 'package:rxdart/rxdart.dart';

class EditAccountBloc {
  final BehaviorSubject<String> dropdownValue = BehaviorSubject<String>();

  Stream<String> get genderStream => dropdownValue.stream;

  dynamic updateSelectedGender(String gender) {
    dropdownValue.sink.add(gender);
  }

  Future<File> compressImage(File imageFile, int width) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    final int rand = math.Random().nextInt(10000);
    final img.Image image = img.decodeImage(imageFile.readAsBytesSync());
    final img.Image smallerImage = img.copyResize(image, width: width);
    final compressedImage = File('$path/img_$rand.jpg')
      ..writeAsBytesSync(img.encodeJpg(smallerImage, quality: 100));
    return compressedImage;
  }
}

EditAccountBloc editAccountBloc = EditAccountBloc();
