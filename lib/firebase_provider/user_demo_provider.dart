//import 'package:byebye_flutter_app/my_constants/design_system.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

///This functionality commented because we don't require we change it to simple text note.
//class UserDemoProvider {
//  final Firestore _firestore = Firestore.instance;
//
//  Future<bool> addDemoGenreApi(uid) async {
//    bool result = false;
//    int bookVolumeCounter = 0;
//    int bookPriceCounter = 0;
//
//    final List demoGenre = [
//      {
//        'createdOn': DateTime.now(),
//        'genreName': 'DEMO CATEGORY #1',
//        'uid': uid
//      },
//      {
//        'createdOn': DateTime.now(),
//        'genreName': 'DEMO CATEGORY #2',
//        'uid': uid
//      },
//    ];
//
//    final List demoBooks = [
//      {
//        'uid': uid,
//        'bookName': 'First Demo Item',
//        'bookGenre': 'DEMO CATEGORY #1',
//        'bookPrice': '10',
//        'bookVolumes': '1',
//        'bookPurchaseDate': DateTime.now(),
//        'bookPhoto': '',
//        'sellerLink': 'sellerLink',
//        'descriptionOfBook': 'This is Your demo book',
//        'regretOfBook': '',
//        'favourite': true,
//        'bookRead': 0,
//        'createdOn': DateTime.now(),
//      },
//      {
//        'uid': uid,
//        'bookName': 'Second Demo Item',
//        'bookGenre': 'DEMO CATEGORY #1',
//        'bookPrice': '19',
//        'bookVolumes': '1',
//        'bookPurchaseDate': DateTime.now(),
//        'bookPhoto': 'https://source.unsplash.com/collection/1103088/',
//        'sellerLink': '',
//        'descriptionOfBook': 'This is Your Second demo book',
//        'regretOfBook': '',
//        'favourite': false,
//        'bookRead': 0,
//        'createdOn': DateTime.now(),
//      },
//      {
//        'uid': uid,
//        'bookName': 'Third Demo Item',
//        'bookGenre': 'DEMO CATEGORY #2',
//        'bookPrice': '18',
//        'bookVolumes': '1',
//        'bookPurchaseDate': DateTime.now(),
//        'bookPhoto': '',
//        'sellerLink': '',
//        'descriptionOfBook': '',
//        'regretOfBook': '',
//        'favourite': true,
//        'bookRead': 0,
//        'createdOn': DateTime.now(),
//      },
//      {
//        'uid': uid,
//        'bookName': 'Fourth demo Item',
//        'bookGenre': 'DEMO CATEGORY #2',
//        'bookPrice': '6',
//        'bookVolumes': '3',
//        'bookPurchaseDate': DateTime.now(),
//        'bookPhoto': '',
//        'sellerLink': '',
//        'descriptionOfBook': 'The Fourth Demo Book',
//        'regretOfBook': '',
//        'favourite': false,
//        'bookRead': 0,
//        'createdOn': DateTime.now(),
//      },
//    ];
//
//    final Query query =
//        _firestore.collection('genres').where('uid', isEqualTo: uid);
//    final QuerySnapshot querySnapshot = await query.getDocuments();
//    if (querySnapshot.documents.isEmpty) {
//      for (dynamic genre in demoGenre) {
//        final WriteBatch _batch = Firestore.instance.batch();
//        _batch.setData(_firestore.collection('genres').document(), genre);
//        await _batch.commit();
//      }
//      for (dynamic book in demoBooks) {
//        final WriteBatch _batch = Firestore.instance.batch();
//        _batch.setData(_firestore.collection('library').document(), book);
//        await _batch.commit();
//      }
//      _firestore
//          .collection('library')
//          .where('uid', isEqualTo: uid)
//          .getDocuments()
//          .then((onValue) {
//        for (DocumentSnapshot library in onValue.documents) {
//          if (library['uid'] == uid) {
//            final int bookVolume = int.parse(library['bookVolumes']);
//            final int bookPrice = int.parse(library['bookPrice']);
//            bookVolumeCounter = bookVolumeCounter + bookVolume;
//            bookPriceCounter = bookPriceCounter + bookPrice;
//          }
//          _firestore.collection('users').document(uid).updateData({
//            'totalBooksVolume': bookVolumeCounter,
//            'totalBooksPrice': bookPriceCounter
//          });
//          prefsObject.setInt('totalBooksVolume', bookVolumeCounter);
//          prefsObject.setInt('totalBooksPrice', bookPriceCounter);
//        }
//      });
//      result = true;
//    }
//    return result;
//  }
//}
