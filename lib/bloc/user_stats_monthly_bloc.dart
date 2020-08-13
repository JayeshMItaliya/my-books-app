import 'package:byebye_flutter_app/constants/strings.dart';
import 'package:byebye_flutter_app/firebase_repository/firebase_repository.dart';
import 'package:byebye_flutter_app/network_helper/stats_genre_helper.dart';
import 'package:byebye_flutter_app/network_helper/user_specific_stats_helper.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

class UserStatsMonthlyBloc {
  final _firebaseRepository = FirebaseRepository();
  final BehaviorSubject<String> dropdownMonthlyValue =
      BehaviorSubject<String>();
  final BehaviorSubject<List<dynamic>> selectedAllFilterList =
      BehaviorSubject<List<dynamic>>();

  Stream<String> get timePeriodMonthlyStream => dropdownMonthlyValue.stream;
  Stream<List<dynamic>> get selectedFilterDataStream =>
      selectedAllFilterList.stream;

  StatsGenreHelper genreData;

  dynamic updateSelectedMonthlyTime(String value) {
    dropdownMonthlyValue.sink.add(value);
    getMonthlyStats(monthlyValue: value);
  }

  dynamic updateSelectedFilterData(List<dynamic> selectedFilterDataVal) {
    selectedAllFilterList.add(selectedFilterDataVal);
  }

  StatsFilterMonthlyHelper statsFilterMonthlyHelper;

  dynamic getMonthlyStats({String monthlyValue}) async {
    statsFilterMonthlyHelper =
        await _firebaseRepository.onGetMonthlyStats(monthlyValue: monthlyValue);
  }

  dynamic updateCustomRange(DateTime selectedMonth) {
    final monthFormat = DateFormat('MMM-yyyy');
    final String range = '${monthFormat.format(selectedMonth)}';
    dropdownMonthlyValue.sink.add(range);
    getspecificBook(selectedMonth: selectedMonth, value: Strings.statsCustom);
  }

  dynamic getspecificBook({DateTime selectedMonth, String value}) async {
    statsFilterMonthlyHelper = await _firebaseRepository.onGetMonthlyStats(
        monthlyValue: value, selectedMonth: selectedMonth);
  }
}

UserStatsMonthlyBloc userStatsMonthlyBloc = UserStatsMonthlyBloc();
