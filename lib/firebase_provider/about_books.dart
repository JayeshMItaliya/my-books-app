import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:byebye_flutter_app/network_helper/about_user_book_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AboutBooks {
  final Firestore _firestore = Firestore.instance;

  Future<AboutUserBookHelper> onGetAboutBooksApi(String genreName) async {
    QuerySnapshot querySnapshot;
    Query query = _firestore
        .collection('library')
        .where('uid', isEqualTo: prefsObject.getString('uid'));
    if (genreName == 'All') {
      querySnapshot = await query.getDocuments();
    } else {
      query = query.where('bookGenre', isEqualTo: genreName);
      querySnapshot = await query.getDocuments();
    }
    return AboutUserBookHelper(parsedResponse: querySnapshot.documents);
  }
}
