import 'package:byebye_flutter_app/network_helper/user_book_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserBookProvider {
  final Firestore _firestore = Firestore.instance;

  Future<UserBookHelper> onGetUserBooksApi(
      String genreName, String userUid) async {
    QuerySnapshot querySnapshotLibrary;
    QuerySnapshot querySnapshotGenres;
    Query queryLibrary =
        _firestore.collection('library').where('uid', isEqualTo: userUid);
    if (genreName == 'All') {
      final Query queryGenre =
          _firestore.collection('genres').where('uid', isEqualTo: userUid);
      querySnapshotGenres = await queryGenre.getDocuments();
      querySnapshotLibrary = await queryLibrary.getDocuments();
    } else {
      Query queryGenre =
          _firestore.collection('genres').where('uid', isEqualTo: userUid);
      queryGenre = queryGenre.where('genreName', isEqualTo: genreName);
      querySnapshotGenres = await queryGenre.getDocuments();
      queryLibrary = queryLibrary.where('bookGenre', isEqualTo: genreName);
      querySnapshotLibrary = await queryLibrary.getDocuments();
    }
    return UserBookHelper(
        parsedBookResponse: querySnapshotLibrary.documents,
        parsedGenreResponse: querySnapshotGenres.documents);
  }
}
