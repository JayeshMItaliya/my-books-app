import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:byebye_flutter_app/network_helper/book_lover_helper.dart';
import 'package:byebye_flutter_app/network_helper/highlight_book_lover_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookLoversProvider {
  final Firestore _firestore = Firestore.instance;

  Future<BookLoverHelper> onGetAllBookLoversApi() async {
    final Query queryUser =
        _firestore.collection('users').orderBy('createdOn', descending: true);
    final QuerySnapshot querySnapshotUser = await queryUser.getDocuments();
    return BookLoverHelper(
      parsedUserResponse: querySnapshotUser.documents,
    );
  }

  Future<BookLoverHelper> onGetBookLoversApi() async {
    final Query queryUser = _firestore
        .collection('users')
        .orderBy('createdOn', descending: true)
        .limit(80);
    final QuerySnapshot querySnapshotUser = await queryUser.getDocuments();
    return BookLoverHelper(
        parsedUserResponse: querySnapshotUser.documents,
        lastBookLoverData: querySnapshotUser);
  }

  Future<BookLoverHelper> onGetNextBookLoversApi(dynamic documentList) async {
    final Query queryUser = _firestore
        .collection('users')
        .orderBy('createdOn', descending: true)
        .startAfterDocument(documentList[documentList.length - 1])
        .limit(80);
    final QuerySnapshot querySnapshotUser = await queryUser.getDocuments();
    if (documentList != null && querySnapshotUser.documents.isNotEmpty) {
      if (documentList[documentList.length - 1].documentID !=
          querySnapshotUser
              .documents[querySnapshotUser.documents.length - 1].documentID) {
        return BookLoverHelper(
            parsedUserResponse: querySnapshotUser.documents,
            lastBookLoverData: querySnapshotUser);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<BookLoverHelper> onGetActiveBookLoversApi() async {
    final Query queryUser = _firestore
        .collection('users')
        .orderBy('createdOn', descending: true)
        .limit(150);
    final QuerySnapshot querySnapshotUser = await queryUser.getDocuments();
    return BookLoverHelper(
        parsedUserResponse: querySnapshotUser.documents,
        lastActiveBookLoverData: querySnapshotUser);
  }

  Future<BookLoverHelper> onGetNextActiveBookLoversApi(
      dynamic documentList) async {
    final Query queryUser = _firestore
        .collection('users')
        .orderBy('createdOn', descending: true)
        .startAfterDocument(documentList[documentList.length - 1])
        .limit(150);
    final QuerySnapshot querySnapshotUser = await queryUser.getDocuments();
    if (documentList != null && querySnapshotUser.documents.isNotEmpty) {
      if (documentList[documentList.length - 1].documentID !=
          querySnapshotUser
              .documents[querySnapshotUser.documents.length - 1].documentID) {
        return BookLoverHelper(
            parsedUserResponse: querySnapshotUser.documents,
            lastActiveBookLoverData: querySnapshotUser);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<HighLightBookLoverHelper> onGetHighLightUserApi() async {
    final Query queryUser =
        _firestore.collection('users').orderBy('createdOn', descending: true);
    final QuerySnapshot querySnapshotUser = await queryUser.getDocuments();
    return HighLightBookLoverHelper(
      parsedUserResponse: querySnapshotUser.documents,
    );
  }

  Future<dynamic> onAddAndRemoveToBookmarkedApi(
      String userId, bool bookmarkedValue) async {
    bool result = false;
    dynamic error;

    if (bookmarkedValue) {
      await _firestore.collection('users').document(userId).updateData({
        'fans': FieldValue.arrayUnion([prefsObject.getString('uid')])
      }).catchError((e) {
        error = e.toString();
      }).then((_) {
        result = true;
      });
    } else {
      await _firestore.collection('users').document(userId).updateData({
        'fans': FieldValue.arrayRemove([prefsObject.getString('uid')])
      }).catchError((e) {
        error = e.toString();
      }).then((_) {
        result = true;
      });
    }

    return [result, error];
  }

  Future<dynamic> onAddUserViewCountApi(String userId, int views) async {
    bool result = false;
    dynamic error;
    views = views + 1;

    await _firestore
        .collection('users')
        .document(userId)
        .updateData({'views': views}).catchError((e) {
      error = e.toString();
    }).then((_) {
      result = true;
    });
    return [result, error];
  }
}
