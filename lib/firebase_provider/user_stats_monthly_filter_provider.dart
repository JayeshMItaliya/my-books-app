import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:byebye_flutter_app/network_helper/user_specific_stats_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SpecificMonthlyStatsProvider {
  final Firestore _firestore = Firestore.instance;
  Future<StatsFilterMonthlyHelper> onGetMonthlyStatsApi(
      {DateTime selectedMonth, String monthlyVal}) async {
    final Query query = _firestore
        .collection('library')
        .where('uid', isEqualTo: prefsObject.getString('uid'));
    final QuerySnapshot libraryQuerySnapshot = await query.getDocuments();
    return StatsFilterMonthlyHelper(
      parsedLibraryResponse: libraryQuerySnapshot.documents,
      selectedMonth: selectedMonth,
      monthlyValue: monthlyVal,
    );
  }
}
