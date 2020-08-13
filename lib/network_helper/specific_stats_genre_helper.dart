import 'package:byebye_flutter_app/constants/constants.dart';
import 'package:byebye_flutter_app/model/genre_stats.dart';
import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:byebye_flutter_app/network_helper/stats_genre_helper.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class SpecificStatsGenreHelper {
  SpecificStatsGenreHelper(
      {dynamic parsedLibraryResponse,
      String timePeriod,
      DateTime startDate,
      DateTime endDate,
      String genreName}) {
    int bookValue = 0;
    int regretValue = 0;
    int books = 0;
    int regretBook = 0;
    int monthValueOfPrice = 0;
    int monthValueOfVolume = 0;
    final List<int> monthlyValueOfGenre = [];
    final List<int> monthlyVolumeOfGenre = [];

    //To Generate Graph Data.
    dynamic generateGraphData(String interval, parsedLibraryResponse) {
      final date = DateTime.now();
      int time = 0;
      int year = 0;

      switch (interval) {
        case 'Current Year':
          {
            time = date.year;
          }
          break;
        case 'Last Year':
          {
            time = date.year - 1;
          }
          break;
        case 'Current Month':
          {
            time = date.month;
            year = date.year;
          }
          break;
        case 'Last Month':
          {
            time = date.month - 1;
            year = date.year;
          }
          break;
      }

      monthInWord = [];
      final List<int> test = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
      for (int single in test) {
        monthValueOfPrice = 0;
        monthValueOfVolume = 0;
        for (dynamic book in parsedLibraryResponse) {
          if (single == book['bookPurchaseDate'].toDate().month) {
            if (interval == 'Current Year' || interval == 'Last Year') {
              if (time == book['bookPurchaseDate'].toDate().year) {
                monthValueOfPrice += int.parse(book['bookPrice']);
                monthValueOfVolume += int.parse(book['bookVolumes']);
              }
            } else {
              if (time == book['bookPurchaseDate'].toDate().month &&
                  year == book['bookPurchaseDate'].toDate().year) {
                monthValueOfPrice += int.parse(book['bookPrice']);
                monthValueOfVolume += int.parse(book['bookVolumes']);
              }
            }
          }
        }
        if (monthValueOfPrice == 0 && monthValueOfVolume == 0) {
          monthlyValueOfGenre.add(0);
          monthlyVolumeOfGenre.add(0);
        } else {
          monthlyValueOfGenre.add(monthValueOfPrice);
          monthlyVolumeOfGenre.add(monthValueOfVolume);
        }
      }

      for (int i = 0; i < test.length; i++) {
        for (int j = 0; j < Constants.monthList.length; j++) {
          if (i == j) {
            monthInWord.add(Constants.monthList[j]);
          }
        }
      }

      for (int i = 0; i < monthlyValueOfGenre.length; i++) {
        spentGraphData.add(SubscriberSeries(
            monthX: monthInWord[i],
            subscribersY: monthlyValueOfGenre[i],
            barColor: charts.ColorUtil.fromDartColor(myPrimaryColor)));
      }

      for (int i = 0; i < monthlyVolumeOfGenre.length; i++) {
        booksGraphData.add(SubscriberSeries(
            monthX: monthInWord[i],
            subscribersY: monthlyVolumeOfGenre[i],
            barColor: charts.ColorUtil.fromDartColor(myPrimaryColor)));
      }
    }

    if (parsedLibraryResponse.isNotEmpty) {
      final date = DateTime.now();
      int time = 0;
      int year = 0;

      switch (timePeriod) {
        case 'Current Year':
          {
            time = date.year;
          }
          break;
        case 'Last Year':
          {
            time = date.year - 1;
          }
          break;
        case 'Current Month':
          {
            time = date.month;
            year = date.year;
          }
          break;
        case 'Last Month':
          {
            time = date.month - 1;
            year = date.year;
          }
          break;
        case 'Custom':
          {
            time = -1;
          }
          break;
      }
      for (dynamic book in parsedLibraryResponse) {
        if (timePeriod == 'All Time') {
          bookValue += int.parse(book['bookPrice']);
          books += int.parse(book['bookVolumes']);
          if (book['regretOfBook'] != '') {
            regretValue += int.parse(book['bookPrice']);
            regretBook += int.parse(book['bookVolumes']);
          }
        } else if (timePeriod == 'Current Year' || timePeriod == 'Last Year') {
          if (time == book['bookPurchaseDate'].toDate().year) {
            bookValue += int.parse(book['bookPrice']);
            books += int.parse(book['bookVolumes']);
            if (book['regretOfBook'] != '') {
              regretValue += int.parse(book['bookPrice']);
              regretBook += int.parse(book['bookVolumes']);
            }
          }
        } else if (timePeriod == 'Current Month' ||
            timePeriod == 'Last Month') {
          if (year == book['bookPurchaseDate'].toDate().year &&
              time == book['bookPurchaseDate'].toDate().month) {
            bookValue += int.parse(book['bookPrice']);
            books += int.parse(book['bookVolumes']);
            if (book['regretOfBook'] != '') {
              regretValue += int.parse(book['bookPrice']);
              regretBook += int.parse(book['bookVolumes']);
            }
          }
        } else {
          final date = DateTime(endDate.year, endDate.month + 1, 0);
          endDate = date;
          final genreDate = book['bookPurchaseDate'].toDate();
          if (genreDate.isAfter(startDate) && genreDate.isBefore(endDate)) {
            bookValue += int.parse(book['bookPrice']);
            books += int.parse(book['bookVolumes']);
            if (book['regretOfBook'] != '') {
              regretValue += int.parse(book['bookPrice']);
              regretBook += int.parse(book['bookVolumes']);
            }
          }
        }
      }
      libraryStats.add(StatsGenre(
          value: bookValue,
          book: books,
          regretBooks: regretBook,
          regretValues: regretValue));
      if (timePeriod == 'Custom' || timePeriod == 'All Time') {
        spentGraphData = [];
        booksGraphData = [];
      } else if (genreName == 'All Genres') {
        spentGraphData = [];
        booksGraphData = [];
      } else {
        generateGraphData(timePeriod, parsedLibraryResponse);
      }
    } else {
      libraryStats = [];
      spentGraphData = [];
      booksGraphData = [];
    }
  }

  List<String> monthInWord = [];
  List<dynamic> libraryStats = [];
  List<SubscriberSeries> spentGraphData = [];
  List<SubscriberSeries> booksGraphData = [];
}
