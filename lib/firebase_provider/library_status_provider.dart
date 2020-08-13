import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LibraryStatusProvider {
  final Firestore _firestore = Firestore.instance;

  Future<dynamic> onGetLibraryStatusApi() async {
    bool result = false;
    dynamic response;

    final Query query = _firestore
        .collection('users')
        .where('uid', isEqualTo: prefsObject.getString('uid'));
    final QuerySnapshot querySnapshot = await query.getDocuments();
    response = querySnapshot.documents;
    if (response[0].data['libraryStatus']) {
      result = true;
    } else {
      result = false;
    }

    return result;
  }

  Future<dynamic> onChangeLibraryStatusApi(bool status) async {
    dynamic error;
    bool result = false;

    await _firestore
        .collection('users')
        .document(prefsObject.getString('uid'))
        .updateData({'libraryStatus': status}).catchError((e) {
      error = e.toString();
    }).then((_) {
      result = true;
    });
    return [result, error];
  }
}
