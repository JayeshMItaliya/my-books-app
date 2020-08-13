import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:byebye_flutter_app/network_helper/about_user_genre_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AboutGenres {
  final Firestore _firestore = Firestore.instance;

  Future<AboutUserGenreHelper> onGetAboutGenresApi() async {
    final Query query = _firestore
        .collection('library')
        .where('uid', isEqualTo: prefsObject.getString('uid'));
    final QuerySnapshot querySnapshot = await query.getDocuments();
    return AboutUserGenreHelper(parsedResponse: querySnapshot.documents);
  }
}
