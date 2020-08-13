import 'dart:math';

import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddNewBook {
  final Firestore _firestore = Firestore.instance;
  List<DocumentSnapshot> booksList = [];

  Future<dynamic> addNewBookApi(
    String bookName,
    String bookGenre,
    String bookPrice,
    String bookVolumes,
    DateTime bookPurchaseDate,
    dynamic bookPhoto,
    String sellerLink,
    String descriptionOfBook,
  ) async {
    bool result = true;
    dynamic error;

    //To upload book image in firebase storage.
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
          storageReference.putFile(bookPhoto);
      final downloadUrl =
          await (await storageUploadTask.onComplete).ref.getDownloadURL();
      final StorageTaskSnapshot storageTaskSnapshot =
          await storageUploadTask.onComplete;
      return [downloadUrl, storageTaskSnapshot];
    }

    //Update new Book Volume in usertable

    Future<dynamic> updateTotalBooksData() async {
      final int newBookVolume = int.parse(bookVolumes);
      final int newBookPrice = int.parse(bookPrice);
      await _firestore
          .collection('users')
          .document(prefsObject.getString('uid'))
          .get()
          .then((onValue) {
        final int oldTotalBooksVolume = onValue['totalBooksVolume'] ?? 0;
        final int oldTotalBooksPrice = onValue['totalBooksPrice'] ?? 0;
        if (oldTotalBooksVolume != null) {
          _firestore
              .collection('users')
              .document(prefsObject.getString('uid'))
              .updateData(
                  {'totalBooksVolume': oldTotalBooksVolume + newBookVolume});
          prefsObject.setInt(
              'totalBooksVolume', oldTotalBooksVolume + newBookVolume);
        } else {
          _firestore
              .collection('users')
              .document(prefsObject.getString('uid'))
              .updateData({'totalBooksVolume': newBookVolume});
          prefsObject.setInt('totalBooksVolume', newBookVolume);
        }
        if (oldTotalBooksPrice != null) {
          _firestore
              .collection('users')
              .document(prefsObject.getString('uid'))
              .updateData(
                  {'totalBooksPrice': oldTotalBooksPrice + newBookPrice});
          prefsObject.setInt(
              'totalBooksPrice', oldTotalBooksVolume + newBookPrice);
        } else {
          _firestore
              .collection('users')
              .document(prefsObject.getString('uid'))
              .updateData({'totalBooksPrice': newBookPrice});
          prefsObject.setInt('totalBooksPrice', newBookPrice);
        }
      });
    }

    final Query query = _firestore.collection('library');
    final QuerySnapshot querySnapshot = await query.getDocuments();

    if (querySnapshot.documents.isEmpty) {
      if (bookPhoto != '') {
        final dynamic uploadResult = await uploadBookPhoto(bookPhoto);
        if (uploadResult[1].error == null) {
          await _firestore.collection('library').document().setData({
            'uid': prefsObject.getString('uid'),
            'bookName': bookName,
            'bookGenre': bookGenre,
            'bookPrice': bookPrice,
            'bookVolumes': bookVolumes,
            'bookPurchaseDate': bookPurchaseDate,
            'bookPhoto': uploadResult[0].toString(),
            'sellerLink': sellerLink,
            'descriptionOfBook': descriptionOfBook,
            'regretOfBook': '',
            'favourite': false,
            'bookRead': 0,
            'createdOn': DateTime.now(),
          }).catchError((e) {
            error = e.toString();
          }).then((_) async {
            await updateTotalBooksData().then((_) {
              result = true;
            });
          });
        }
      } else {
        await _firestore.collection('library').document().setData({
          'uid': prefsObject.getString('uid'),
          'bookName': bookName,
          'bookGenre': bookGenre,
          'bookPrice': bookPrice,
          'bookVolumes': bookVolumes,
          'bookPurchaseDate': bookPurchaseDate,
          'bookPhoto': bookPhoto,
          'sellerLink': sellerLink,
          'descriptionOfBook': descriptionOfBook,
          'regretOfBook': '',
          'favourite': false,
          'bookRead': 0,
          'createdOn': DateTime.now(),
        }).catchError((e) {
          error = e.toString();
        }).then((_) async {
          await updateTotalBooksData().then((_) {
            result = true;
          });
        });
      }
    } else {
      booksList = [];
      booksList = querySnapshot.documents;
      for (DocumentSnapshot book in booksList) {
        if (book.data['uid'] == prefsObject.getString('uid') &&
            book.data['bookName'] == bookName &&
            book.data['bookGenre'] == bookGenre) {
          result = false;
          break;
        }
      }
      if (result) {
        if (bookPhoto != '') {
          final dynamic uploadResult = await uploadBookPhoto(bookPhoto);
          if (uploadResult[1].error == null) {
            await _firestore.collection('library').document().setData({
              'uid': prefsObject.getString('uid'),
              'bookName': bookName,
              'bookGenre': bookGenre,
              'bookPrice': bookPrice,
              'bookVolumes': bookVolumes,
              'bookPurchaseDate': bookPurchaseDate,
              'bookPhoto': uploadResult[0].toString(),
              'sellerLink': sellerLink,
              'descriptionOfBook': descriptionOfBook,
              'regretOfBook': '',
              'favourite': false,
              'bookRead': 0,
              'createdOn': DateTime.now(),
            }).catchError((e) {
              error = e.toString();
            }).then((_) async {
              await updateTotalBooksData().then((_) {
                result = true;
              });
            });
          }
        } else {
          await _firestore.collection('library').document().setData({
            'uid': prefsObject.getString('uid'),
            'bookName': bookName,
            'bookGenre': bookGenre,
            'bookPrice': bookPrice,
            'bookVolumes': bookVolumes,
            'bookPurchaseDate': bookPurchaseDate,
            'bookPhoto': bookPhoto,
            'sellerLink': sellerLink,
            'descriptionOfBook': descriptionOfBook,
            'regretOfBook': '',
            'favourite': false,
            'bookRead': 0,
            'createdOn': DateTime.now(),
          }).catchError((e) {
            error = e.toString();
          }).then((_) async {
            await updateTotalBooksData().then((_) {
              result = true;
            });
          });
        }
      }
    }

    return [result, error];
  }
}
