import 'package:byebye_flutter_app/network_helper/user_connection_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserConnectionProvider {
  final Firestore _firestore = Firestore.instance;

  Future<UserConnectionHelper> onGetUserConnectionListApi(
      String userUid) async {
    final Query queryUser = _firestore.collection('users');
    final QuerySnapshot queryUserSnapshot = await queryUser.getDocuments();

    return UserConnectionHelper(
        parsedUserResponse: queryUserSnapshot.documents, userId: userUid);
  }
}
