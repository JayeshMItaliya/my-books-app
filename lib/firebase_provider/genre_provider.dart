import 'package:byebye_flutter_app/network_helper/genre_helper.dart';
import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GenreProvider {
  final Firestore _firestore = Firestore.instance;

  Future<GenreHelper> onGetGenreApi(String userUid) async {
    final Query query =
        _firestore.collection('genres').where('uid', isEqualTo: userUid);
    final QuerySnapshot querySnapshot = await query.getDocuments();
    final Query queryLibrary =
        _firestore.collection('library').where('uid', isEqualTo: userUid);
    final QuerySnapshot querySnapshotLibrary =
        await queryLibrary.getDocuments();
    return GenreHelper(
        parsedGenreResponse: querySnapshot.documents,
        parsedLibraryResponse: querySnapshotLibrary.documents);
  }

  Future<dynamic> onEditGenreApi(
      String genreName, String oldGenreName, String genreId) async {
    List<DocumentSnapshot> genreList = [];
    bool result = false;
    dynamic error;

    final Query query = _firestore
        .collection('genres')
        .where('uid', isEqualTo: prefsObject.getString('uid'));
    final QuerySnapshot querySnapshot = await query.getDocuments();
    genreList = querySnapshot.documents;

    for (DocumentSnapshot genres in genreList) {
      if (genres.data['genreName'] == genreName) {
        result = true;
        break;
      }
    }
    if (!result) {
      await _firestore.collection('genres').document(genreId).updateData({
        'genreName': genreName,
      }).catchError((e) {
        error = e.toString();
      }).then((_) async {
        Query query = _firestore
            .collection('library')
            .where('uid', isEqualTo: prefsObject.getString('uid'));
        final QuerySnapshot querySnapshot = await query.getDocuments();
        if (querySnapshot.documents.isEmpty) {
          result = false;
        } else {
          query = query.where('bookGenre', isEqualTo: oldGenreName);
          final QuerySnapshot querySnapshot = await query.getDocuments();
          if (querySnapshot.documents.isEmpty) {
            result = false;
          } else {
            for (DocumentSnapshot book in querySnapshot.documents) {
              _firestore
                  .collection('library')
                  .document(book.documentID)
                  .updateData({'bookGenre': genreName});
            }
            result = false;
          }
        }
      });
      return [result, error];
    } else {
      return [result, error];
    }
  }

  Future<dynamic> onDeleteGenreApi(String genreName, String genreId) async {
    List<DocumentSnapshot> libraryList = [];
    bool result = false;
    dynamic error;

    final Query query = _firestore
        .collection('library')
        .where('uid', isEqualTo: prefsObject.getString('uid'));
    final QuerySnapshot querySnapshot = await query.getDocuments();
    libraryList = querySnapshot.documents;

    for (DocumentSnapshot book in libraryList) {
      if (book.data['bookGenre'] == genreName &&
          book.data['uid'] == prefsObject.getString('uid')) {
        result = true;
        break;
      }
    }
    if (!result) {
      await _firestore
          .collection('genres')
          .document(genreId)
          .delete()
          .catchError((e) {
        error = e.toString();
      }).then((_) {
        result = false;
      });
      return [result, error];
    } else {
      return [result, error];
    }
  }
}
