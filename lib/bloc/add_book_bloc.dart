import 'dart:io';
import 'dart:math' as math;
import 'package:byebye_flutter_app/firebase_repository/firebase_repository.dart';
import 'package:byebye_flutter_app/network_helper/create_book_helper.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

import 'package:rxdart/rxdart.dart';

class AddBookBloc {
  final _firebaseRepository = FirebaseRepository();

  BehaviorSubject<String> genreValue = BehaviorSubject<String>();

  Stream<String> get genreStream => genreValue.stream;

  dynamic updateSelectedGenre(String genre) {
    genreValue.sink.add(genre);
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

  dynamic createBook(CreateBookHelper createBookHelper) async {
    final String bookName = createBookHelper.bookName;
    final String bookGenre = createBookHelper.bookGenre;
    final String bookPrice = createBookHelper.bookPrice;
    final String bookVolumes = createBookHelper.bookVolumes;
    final DateTime bookPurchaseDate = createBookHelper.bookPurchaseDate;
    final dynamic bookPhoto = createBookHelper.bookPhoto;
    final String sellerLink = createBookHelper.sellerLink;
    final String descriptionOfBook = createBookHelper.descriptionOfBook;
    final dynamic response = await _firebaseRepository.addNewBook(
      bookName,
      bookGenre,
      bookPrice,
      bookVolumes,
      bookPurchaseDate,
      bookPhoto,
      sellerLink,
      descriptionOfBook,
    );
    return response;
  }


}

AddBookBloc addBookBloc = AddBookBloc();
