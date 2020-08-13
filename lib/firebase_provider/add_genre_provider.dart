import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddGenreProvider {
  final Firestore _firestore = Firestore.instance;
  List<DocumentSnapshot> genresList = [];

  Future<dynamic> addNewGenreApi(String genreName) async {
    bool result = false;
    final Query query = _firestore.collection('genres');
    final QuerySnapshot querySnapshot = await query.getDocuments();
    if (querySnapshot.documents.isEmpty) {
      await _firestore.collection('genres').document().setData({
        'genreName': genreName,
        'uid': prefsObject.getString('uid'),
        'createdOn': DateTime.now(),
      }).catchError((e) {
        print(e);
      });
    } else {
      genresList = [];
      genresList = querySnapshot.documents;
      for (DocumentSnapshot genres in genresList) {
        if (genres.data['uid'] == prefsObject.getString('uid') &&
            genres.data['genreName'] == genreName) {
          result = true;
          break;
        }
      }
      if (!result) {
        await _firestore.collection('genres').document().setData({
          'genreName': genreName,
          'uid': prefsObject.getString('uid'),
          'createdOn': DateTime.now(),
        }).then((_) {
          return result;
        });
      }
      return result;
    }
  }
}
