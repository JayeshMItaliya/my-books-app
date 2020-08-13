import 'package:byebye_flutter_app/network_helper/people_filter_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SpecificPeopleFilterProvider {
  final Firestore _firestore = Firestore.instance;
  Future<PeopleFilterHelper> onGetSpecificFilterApi(
      {String genderValue,
      String ageValue,
      String inventoryVal,
      String activityVal}) async {
    final Query userQuery =
        _firestore.collection('users').orderBy('createdOn', descending: true);
    final QuerySnapshot userQuerySnapshot = await userQuery.getDocuments();
    return PeopleFilterHelper(
      parsedUserResponse: userQuerySnapshot.documents,
      genderValue: genderValue,
      ageValue: ageValue,
      inventoryVal: inventoryVal,
      activityVal: activityVal,
    );
  }
}
