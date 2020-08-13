import 'package:byebye_flutter_app/network_helper/stats_genre_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SpecificGenreProvider {
  final Firestore _firestore = Firestore.instance;

  Future<StatsGenreHelper> onGetSpecificGenreApi(uid,
      {DateTime startDate, DateTime endDate, String value}) async {
    final Query libraryQuery = _firestore
        .collection('library')
        .where('uid', isEqualTo: uid)
        .orderBy('createdOn', descending: false);
    final QuerySnapshot libraryQuerySnapshot =
        await libraryQuery.getDocuments();

    return StatsGenreHelper(
        parsedLibraryResponse: libraryQuerySnapshot.documents,
        value: value,
        startDate: startDate,
        endDate: endDate);
  }
}
