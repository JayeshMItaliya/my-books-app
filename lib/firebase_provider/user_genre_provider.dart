import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:byebye_flutter_app/network_helper/user_genre_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserGenreProvider {
  final Firestore _firestore = Firestore.instance;

  Future<dynamic> onGetUserGenreApi(String userUid) async {
    final Query query =
        _firestore.collection('genres').where('uid', isEqualTo: userUid);
    final QuerySnapshot querySnapshot = await query.getDocuments();
    final Query queryLibrary =
        _firestore.collection('library').where('uid', isEqualTo: userUid);
    final QuerySnapshot querySnapshotLibrary =
        await queryLibrary.getDocuments();
    return UserGenreHelper(
        parsedGenreResponse: querySnapshot.documents,
        parsedLibraryResponse: querySnapshotLibrary.documents);
  }

  Future<dynamic> onBlockUserApi(String userUid) async {
    bool result = false;
    dynamic error;
    await _firestore.collection('users').document(userUid).updateData({
      'blockedBy': FieldValue.arrayUnion([prefsObject.getString('uid')])
    }).catchError((e) {
      error = e.toString();
    }).then((_) {
      result = true;
    });
    return [result, error];
  }
}
