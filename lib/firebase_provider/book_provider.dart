import 'dart:math';

import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:byebye_flutter_app/network_helper/book_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class BookProvider {
  final Firestore _firestore = Firestore.instance;

  Future<BookHelper> onGetBookApi(String genreName) async {
    QuerySnapshot querySnapshot;
    Query query = _firestore
        .collection('library')
        .where('uid', isEqualTo: prefsObject.getString('uid'));
    if (genreName == 'All') {
      querySnapshot = await query.getDocuments();
    } else {
      query = query.where('bookGenre', isEqualTo: genreName);
      querySnapshot = await query.getDocuments();
    }
    return BookHelper(parsedBookResponse: querySnapshot.documents);
  }

  Future<dynamic> onReadBookApi(String bookId, int bookRead) async {
    bool result = false;
    dynamic error;

    await _firestore
        .collection('library')
        .document(bookId)
        .updateData({'bookRead': bookRead}).catchError((e) {
      error = e.toString();
    }).then((_) {
      result = true;
    });
    return [result, error];
  }

  Future<dynamic> onEditBookApi(
      String bookId,
      String bookName,
      String bookGenre,
      String bookPrice,
      String bookVolumes,
      DateTime bookPurchaseDate,
      dynamic bookPhoto,
      String sellerLink,
      String descriptionOfBook,
      bool imageEdit) async {
    bool result = false;
    dynamic error;
    int selectedOldBookVol = 0;
    int selectedOldBookPrice = 0;

    //Update new Book Volume in usertable

    Future<dynamic> totalBooksDataAfterEdit() async {
      final int selectedNewBookVol = int.parse(bookVolumes);
      final int selectedNewBookPrice = int.parse(bookPrice);
      await _firestore
          .collection('users')
          .document(prefsObject.getString('uid'))
          .get()
          .then((onValue) {
        final int oldTotalBooksVolume = onValue['totalBooksVolume'] ?? 0;
        final int oldTotalBooksPrice = onValue['totalBooksPrice'] ?? 0;
        if (bookVolumes != '') {
          int totalBookVolume;
          int updatedBookVolume;
          totalBookVolume = oldTotalBooksVolume - selectedOldBookVol;
          updatedBookVolume = totalBookVolume + selectedNewBookVol;
          _firestore
              .collection('users')
              .document(prefsObject.getString('uid'))
              .updateData({
            'totalBooksVolume': updatedBookVolume > 0 ? updatedBookVolume : 0
          });
          prefsObject.setInt('totalBooksVolume',
              updatedBookVolume > 0 ? updatedBookVolume : 0);
        }
        if (bookPrice != '') {
          int totalBookPrice;
          int updatedPrice;
          totalBookPrice = oldTotalBooksPrice - selectedOldBookPrice;
          updatedPrice = totalBookPrice + selectedNewBookPrice;
          _firestore
              .collection('users')
              .document(prefsObject.getString('uid'))
              .updateData(
                  {'totalBooksPrice': updatedPrice > 0 ? updatedPrice : 0});
          prefsObject.setInt(
              'totalBooksPrice', updatedPrice > 0 ? updatedPrice : 0);
        }
      });
    }

    //To upload book image in firebase storage if image is edited.
    Future<dynamic> uploadBookPhoto(dynamic image) async {
      final random = Random();
      final int randomNo = random.nextInt(1000);
      final String imageName = 'bookImage' + randomNo.toString();
      final StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child('bookDetails')
          .child('bookImages')
          .child(imageName);
      final StorageUploadTask storageUploadTask =
          storageReference.putFile(image);
      final downloadUrl =
          await (await storageUploadTask.onComplete).ref.getDownloadURL();
      final StorageTaskSnapshot storageTaskSnapshot =
          await storageUploadTask.onComplete;
      return [downloadUrl, storageTaskSnapshot];
    }

    if (imageEdit) {
      final dynamic uploadResult = await uploadBookPhoto(bookPhoto);
      if (uploadResult[1].error == null) {
        _firestore
            .collection('library')
            .document(bookId)
            .get()
            .then((onValue) async {
          selectedOldBookVol = int.parse(onValue['bookVolumes']);
          selectedOldBookPrice = int.parse(onValue['bookPrice']);
          await _firestore.collection('library').document(bookId).updateData({
            'bookName': bookName,
            'bookGenre': bookGenre,
            'bookPrice': bookPrice,
            'bookVolumes': bookVolumes,
            'bookPurchaseDate': bookPurchaseDate,
            'bookPhoto': uploadResult[0].toString(),
            'sellerLink': sellerLink,
            'descriptionOfBook': descriptionOfBook,
          }).catchError((e) {
            error = e.toString();
          }).then((_) async {
            await totalBooksDataAfterEdit().then((_) {
              result = true;
            });
          });
        });
      }
    } else {
      _firestore
          .collection('library')
          .document(bookId)
          .get()
          .then((onValue) async {
        selectedOldBookVol = int.parse(onValue['bookVolumes']);
        selectedOldBookPrice = int.parse(onValue['bookPrice']);
        await _firestore.collection('library').document(bookId).updateData({
          'bookName': bookName,
          'bookGenre': bookGenre,
          'bookPrice': bookPrice,
          'bookVolumes': bookVolumes,
          'bookPurchaseDate': bookPurchaseDate,
          'bookPhoto': bookPhoto,
          'sellerLink': sellerLink,
          'descriptionOfBook': descriptionOfBook,
        }).catchError((e) {
          error = e.toString();
        }).then((_) async {
          await totalBooksDataAfterEdit().then((_) {
            result = true;
          });
        });
      });
    }
    return [result, error];
  }

  Future<dynamic> onDeleteBookApi(String bookId, String bookName) async {
    bool result = false;
    dynamic error;
    await totalBooksDataAfterDelete(bookId).then((_) async {
      await _firestore
          .collection('library')
          .document(bookId)
          .delete()
          .catchError((e) {
        error = e.toString();
      }).then((_) {
        result = true;
      });
    });
    return [result, error];
  }

  Future<dynamic> totalBooksDataAfterDelete(String bookId) async {
    await _firestore
        .collection('library')
        .document(bookId)
        .get()
        .then((book) async {
      final int selectedBookVolume = int.parse(book['bookVolumes']);
      final int selectedBookPrice = int.parse(book['bookPrice']);
      await _firestore
          .collection('users')
          .document(prefsObject.getString('uid'))
          .get()
          .then((user) async {
        if (selectedBookVolume != null) {
          final int totalBooksVolume = user['totalBooksVolume'] ?? 0;
          int updatedBookVolume;
          updatedBookVolume = totalBooksVolume - selectedBookVolume;
          await _firestore
              .collection('users')
              .document(prefsObject.getString('uid'))
              .updateData({
            'totalBooksVolume': updatedBookVolume > 0 ? updatedBookVolume : 0
          });
          prefsObject.setInt('totalBooksVolume',
              updatedBookVolume > 0 ? updatedBookVolume : 0);
        }
        if (selectedBookPrice != null) {
          final int totalBooksPrice = user['totalBooksPrice'] ?? 0;
          int updatedBookPrice;
          updatedBookPrice = totalBooksPrice - selectedBookPrice;
          await _firestore
              .collection('users')
              .document(prefsObject.getString('uid'))
              .updateData({
            'totalBooksPrice': updatedBookPrice > 0 ? updatedBookPrice : 0
          });
          prefsObject.setInt(
              'totalBooksPrice', updatedBookPrice > 0 ? updatedBookPrice : 0);
        }
      });
    });
  }

  Future<dynamic> onUpdateRegretApi(String bookId, String bookRegret) async {
    bool result = false;
    dynamic error;
    await _firestore
        .collection('library')
        .document(bookId)
        .updateData({'regretOfBook': bookRegret}).catchError((e) {
      error = e.toString();
    }).then((_) {
      result = true;
    });
    return [result, error];
  }

  Future<dynamic> onRemoveRegretApi(String bookId) async {
    bool result = false;
    dynamic error;
    await _firestore
        .collection('library')
        .document(bookId)
        .updateData({'regretOfBook': ''}).catchError((e) {
      error = e.toString();
    }).then((_) {
      result = true;
    });
    return [result, error];
  }

  Future<dynamic> onAddAndRemoveToFavApi(String bookId, bool favValue) async {
    bool result = false;
    dynamic error;
    await _firestore
        .collection('library')
        .document(bookId)
        .updateData({'favourite': favValue}).catchError((e) {
      error = e.toString();
    }).then((_) {
      result = true;
    });
    return [result, error];
  }
}
