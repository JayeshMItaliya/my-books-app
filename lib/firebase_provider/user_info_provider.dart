import 'package:byebye_flutter_app/network_helper/user_info_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfoProvider {
  final Firestore _firestore = Firestore.instance;

  Future<UserInfoHelper> onGetUserLibraryInfoApi(String userId) async {
    final Query userQuery =
        _firestore.collection('users').where('uid', isEqualTo: userId);
    final QuerySnapshot userQuerySnapshot = await userQuery.getDocuments();
    final Query libraryQuery =
        _firestore.collection('genres').where('uid', isEqualTo: userId);
    final QuerySnapshot libraryQuerySnapshot =
        await libraryQuery.getDocuments();

    return UserInfoHelper(
        parsedUserResponse: userQuerySnapshot.documents,
        parsedGenreResponse: libraryQuerySnapshot.documents);
  }
}
