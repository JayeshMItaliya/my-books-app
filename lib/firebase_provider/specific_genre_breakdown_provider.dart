import 'package:byebye_flutter_app/network_helper/stats_genre_breakdown_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SpecificGenreBreakdown {
  final Firestore _firestore = Firestore.instance;

  Future<StatsGenreBreakdownHelper> onGetSpecificGenreBreakdownApi(uid,
      {DateTime startDate, DateTime endDate, String value}) async {
    final Query genreQuery = _firestore
        .collection('genres')
        .where('uid', isEqualTo: uid)
        .orderBy('createdOn', descending: false);
    final QuerySnapshot genreQuerySnapshot = await genreQuery.getDocuments();

    final Query libraryQuery = _firestore
        .collection('library')
        .where('uid', isEqualTo: uid)
        .orderBy('createdOn', descending: false);
    final QuerySnapshot libraryQuerySnapshot =
        await libraryQuery.getDocuments();

    return StatsGenreBreakdownHelper(
        parsedGenreResponse: genreQuerySnapshot.documents,
        parsedLibraryResponse: libraryQuerySnapshot.documents,
        value: value,
        startDate: startDate,
        endDate: endDate);
  }
}
