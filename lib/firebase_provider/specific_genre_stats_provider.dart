import 'package:byebye_flutter_app/network_helper/specific_stats_genre_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SpecificGenreStatsProvider {
  final Firestore _firestore = Firestore.instance;

  Future<SpecificStatsGenreHelper> onGetSpecificGenreStatsApi(
      String genreName, String uid,
      {String timePeriod, DateTime startDate, DateTime endDate}) async {
    QuerySnapshot querySnapshotLibrary;
    Query queryLibrary =
        _firestore.collection('library').where('uid', isEqualTo: uid);

    if (genreName == 'Whole Inventory') {
      querySnapshotLibrary = await queryLibrary.getDocuments();
    } else {
      queryLibrary = queryLibrary.where('bookGenre', isEqualTo: genreName);
      querySnapshotLibrary = await queryLibrary.getDocuments();
    }

    return SpecificStatsGenreHelper(
        parsedLibraryResponse: querySnapshotLibrary.documents,
        timePeriod: timePeriod,
        startDate: startDate,
        endDate: endDate,
        genreName: genreName);
  }
}
