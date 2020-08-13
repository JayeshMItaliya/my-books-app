import 'package:byebye_flutter_app/firebase_repository/firebase_repository.dart';
import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:byebye_flutter_app/network_helper/stats_genre_helper.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

class UserStatsBloc {
  final _firebaseRepository = FirebaseRepository();

  final BehaviorSubject<String> dropdownValue = BehaviorSubject<String>();
  final BehaviorSubject<List<String>> genreDropDownValue =
      BehaviorSubject<List<String>>();
  final BehaviorSubject<List<dynamic>> libraryStats =
      BehaviorSubject<List<dynamic>>();
  final BehaviorSubject<String> genreValue = BehaviorSubject<String>();

  final BehaviorSubject<List<SubscriberSeries>> spentGraphValue =
      BehaviorSubject<List<SubscriberSeries>>();

  final BehaviorSubject<List<SubscriberSeries>> bookGraphValue =
      BehaviorSubject<List<SubscriberSeries>>();

  Stream<String> get timePeriodStream => dropdownValue.stream;

  Stream<List<String>> get specificGenreStream => genreDropDownValue.stream;

  Stream<List<dynamic>> get libraryStatsStream => libraryStats.stream;

  Stream<String> get genreStream => genreValue.stream;

  Stream<List<SubscriberSeries>> get spentGraphStream => spentGraphValue.stream;

  Stream<List<SubscriberSeries>> get bookGraphStream => bookGraphValue.stream;

  dynamic updateSelectedTime(String value) {
    dropdownValue.sink.add(value);
    getSpecificGenre(prefsObject.getString('uid'), value: value);
  }

  dynamic updateCustomRange(
      String timeInterval, DateTime startMonth, DateTime endMonth) {
    final monthFormat = DateFormat('MMM-yyyy');
    if (startMonth.year == endMonth.year &&
        startMonth.month == endMonth.month) {
      final String range = '${monthFormat.format(startMonth)}';
      dropdownValue.sink.add(range);
    } else {
      final String range =
          '${monthFormat.format(startMonth)} ${monthFormat.format(endMonth)}';
      dropdownValue.sink.add(range);
    }
    getSpecificGenre(prefsObject.getString('uid'),
        startDate: startMonth, endDate: endMonth, value: timeInterval);
  }

  StatsGenreHelper genreData;

  dynamic getSpecificGenre(String uid,
      {DateTime startDate, DateTime endDate, String value}) async {
    genreData = await _firebaseRepository.onGetSpecificGenre(uid,
        value: value, startDate: startDate, endDate: endDate);
    genreDropDownValue.sink.add(genreData.genreList);
    libraryStats.sink.add(genreData.libraryStats);
    spentGraphValue.sink.add(genreData.spentGraphData);
    bookGraphValue.sink.add(genreData.booksGraphData);
  }

  dynamic updateGenreValue(String genre,
      {String timePeriod, DateTime startDate, DateTime endDate}) {
    genreValue.sink.add(genre);
    getSpecificGenreStats(genre, prefsObject.getString('uid'),
        timePeriod: timePeriod, startDate: startDate, endDate: endDate);
  }

  dynamic genreStats;

  dynamic getSpecificGenreStats(genre, uid,
      {String timePeriod, DateTime startDate, DateTime endDate}) async {
    genreStats = await _firebaseRepository.onGetSpecificGenreStats(genre, uid,
        timePeriod: timePeriod, startDate: startDate, endDate: endDate);
    libraryStats.sink.add(genreStats.libraryStats);
    spentGraphValue.sink.add(genreStats.spentGraphData);
    bookGraphValue.sink.add(genreStats.booksGraphData);
  }
}

UserStatsBloc userStatsBloc = UserStatsBloc();
