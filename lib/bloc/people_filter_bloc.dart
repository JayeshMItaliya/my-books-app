import 'package:byebye_flutter_app/firebase_repository/firebase_repository.dart';
import 'package:byebye_flutter_app/network_helper/people_filter_helper.dart';
import 'package:rxdart/rxdart.dart';

class PeopleFilterBloc {
  final _firebaseRepository = FirebaseRepository();

  final BehaviorSubject<String> genderDropdownValue = BehaviorSubject<String>();
  final BehaviorSubject<String> ageDropdownValue = BehaviorSubject<String>();
  final BehaviorSubject<String> inventoryDropdownValue =
      BehaviorSubject<String>();
  final BehaviorSubject<String> activityDropdownValue =
      BehaviorSubject<String>();
  final BehaviorSubject<List<dynamic>> selectedAllFilterList =
      BehaviorSubject<List<dynamic>>();

  Stream<String> get genderDropvalueStream => genderDropdownValue.stream;
  Stream<String> get ageDropvalueStream => ageDropdownValue.stream;
  Stream<String> get inventoryDropvalueStream => inventoryDropdownValue.stream;
  Stream<String> get activityDropvalueStream => activityDropdownValue.stream;
  Stream<List<dynamic>> get selectedFilterDataStream =>
      selectedAllFilterList.stream;

  dynamic updateSelectedGender(String value) {
    genderDropdownValue.sink.add(value);
  }

  dynamic updateSelectedAge(String value) {
    ageDropdownValue.sink.add(value);
  }

  dynamic updateSelectedInventory(String value) {
    inventoryDropdownValue.sink.add(value);
  }

  dynamic updateSelectedActivity(String value) {
    activityDropdownValue.sink.add(value);
  }

  dynamic updateSelectedFilterData(List<dynamic> selectedFilterDataVal) {
    selectedAllFilterList.add(selectedFilterDataVal);
  }

  PeopleFilterHelper peopleFilterData;

  dynamic getSpecificPeople(
      {String genderValue,
      String ageValue,
      String inventoryVal,
      String activityVal}) async {
    peopleFilterData = await _firebaseRepository.onGetSpecificFilter(
      genderValue: genderValue,
      ageValue: ageValue,
      inventoryVal: inventoryVal,
      activityVal: activityVal,
    );
  }
}

PeopleFilterBloc peopleFilterBloc = PeopleFilterBloc();
