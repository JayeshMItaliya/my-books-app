import 'package:byebye_flutter_app/constants/constants.dart';
import 'package:byebye_flutter_app/model/genre_stats.dart';
import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:byebye_flutter_app/constants/strings.dart';

class StatsGenreHelper {
  StatsGenreHelper(
      {dynamic parsedLibraryResponse,
      String value,
      DateTime startDate,
      DateTime endDate}) {
    int bookValue = 0;
    int regretValue = 0;
    int books = 0;
    int regretBook = 0;
    int monthValueOfPrice = 0;
    int monthValueOfVolume = 0;
    if (parsedLibraryResponse.isNotEmpty) {
      //To calculate library stats.
      dynamic getLibraryStats(interval, parsedLibraryResponse) {
        final date = DateTime.now();
        int time = 0;
        int year = 0;
        libraryStats = [];
        bookValue = 0;
        regretValue = 0;
        books = 0;
        regretBook = 0;

        switch (interval) {
          case Strings.statsCurrentYear:
            {
              time = date.year;
            }
            break;
          case Strings.statsLastYear:
            {
              time = date.year - 1;
            }
            break;
          case Strings.statsCurrentMonth:
            {
              time = date.month;
              year = date.year;
            }
            break;
          case Strings.statsLastMonth:
            {
              time = date.month - 1;
              year = date.year;
            }
            break;
          case Strings.statsCustom:
            {
              time = 0;
            }
            break;
        }

        for (dynamic book in parsedLibraryResponse) {
          if (interval == Strings.statsCurrentYear ||
              interval == Strings.statsLastYear) {
            if (time == book['bookPurchaseDate'].toDate().year) {
              bookValue += int.parse(book['bookPrice']);
              books += int.parse(book['bookVolumes']);
              if (book['regretOfBook'] != '') {
                regretValue += int.parse(book['bookPrice']);
                regretBook += int.parse(book['bookVolumes']);
              }
            }
          } else if (interval == Strings.statsCurrentMonth ||
              interval == Strings.statsLastMonth) {
            if (time == book['bookPurchaseDate'].toDate().month &&
                year == book['bookPurchaseDate'].toDate().year) {
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
            final purchaseDate = book['bookPurchaseDate'].toDate();
            if (purchaseDate.isAfter(startDate) &&
                purchaseDate.isBefore(endDate)) {
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
      }

      //To Generate Graph Data.
      dynamic generateGraphData(String interval, parsedLibraryResponse) {
        final date = DateTime.now();
        int time = 0;
        int year = 0;
        switch (interval) {
          case Strings.statsCurrentYear:
            {
              time = date.year;
            }
            break;
          case Strings.statsLastYear:
            {
              time = date.year - 1;
            }
            break;
          case Strings.statsCurrentMonth:
            {
              time = date.month;
              year = date.year;
            }
            break;
          case Strings.statsLastMonth:
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
              if (interval == Strings.statsCurrentYear ||
                  interval == Strings.statsLastYear) {
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

      dynamic getAllGenre(parsedLibraryResponse) {
        genreList = [];
        libraryStats = [];
        bookValue = 0;
        regretValue = 0;
        books = 0;
        regretBook = 0;

        for (dynamic book in parsedLibraryResponse) {
          final bool exist = genreList.contains(book['bookGenre']);
          if (!exist) {
            genreList.add(book['bookGenre']);
          }
        }

        for (dynamic book in parsedLibraryResponse) {
          bookValue += int.parse(book['bookPrice']);
          books += int.parse(book['bookVolumes']);
          if (book['regretOfBook'] != '') {
            regretValue += int.parse(book['bookPrice']);
            regretBook += int.parse(book['bookVolumes']);
          }
        }
        if (genreList.isNotEmpty) {
          genreList.insert(0, Strings.statsWholeInventory);
        }

        libraryStats.add(StatsGenre(
            value: bookValue,
            book: books,
            regretBooks: regretBook,
            regretValues: regretValue));
//        generateGraphData(genreMonthList, parsedLibraryResponse);
      }

      dynamic getCurrentYearGenre(parsedLibraryResponse) {
        final DateTime date = DateTime.now();
        genreList = [];
        libraryStats = [];
        bookValue = 0;
        regretValue = 0;
        books = 0;
        regretBook = 0;

        for (dynamic book in parsedLibraryResponse) {
          if (date.year == book['bookPurchaseDate'].toDate().year) {
            final bool exist = genreList.contains(book['bookGenre']);
            if (!exist) {
              genreList.add(book['bookGenre']);
            }
          }
        }

        if (genreList.isNotEmpty) {
          genreList.insert(0, Strings.statsWholeInventory);
        }
        getLibraryStats(Strings.statsCurrentYear, parsedLibraryResponse);

        generateGraphData(Strings.statsCurrentYear, parsedLibraryResponse);
      }

      dynamic getLastYearGenre(parsedLibraryResponse) {
        final DateTime date = DateTime.now();
        genreList = [];
        libraryStats = [];
        bookValue = 0;
        regretValue = 0;
        books = 0;
        regretBook = 0;

        for (dynamic book in parsedLibraryResponse) {
          if (date.year - 1 == book['bookPurchaseDate'].toDate().year) {
            final bool exist = genreList.contains(book['bookGenre']);
            if (!exist) {
              genreList.add(book['bookGenre']);
            }
          }
        }

        if (genreList.isNotEmpty) {
          genreList.insert(0, Strings.statsWholeInventory);
        }
        getLibraryStats(Strings.statsLastYear, parsedLibraryResponse);
        generateGraphData(Strings.statsLastYear, parsedLibraryResponse);
      }

      dynamic getCurrentMonthGenre(parsedLibraryResponse) {
        final DateTime date = DateTime.now();
        genreList = [];
        libraryStats = [];
        bookValue = 0;
        regretValue = 0;
        books = 0;
        regretBook = 0;

        for (dynamic book in parsedLibraryResponse) {
          if (date.month == book['bookPurchaseDate'].toDate().month &&
              date.year == book['bookPurchaseDate'].toDate().year) {
            final bool exist = genreList.contains(book['bookGenre']);
            if (!exist) {
              genreList.add(book['bookGenre']);
            }
          }
        }

        if (genreList.isNotEmpty) {
          genreList.insert(0, Strings.statsWholeInventory);
        }
        getLibraryStats(Strings.statsCurrentMonth, parsedLibraryResponse);
        generateGraphData(Strings.statsCurrentMonth, parsedLibraryResponse);
      }

      dynamic getLastMonthGenre(parsedLibraryResponse) {
        final DateTime date = DateTime.now();
        genreList = [];
        libraryStats = [];
        bookValue = 0;
        regretValue = 0;
        books = 0;
        regretBook = 0;

        for (dynamic book in parsedLibraryResponse) {
          if (date.month - 1 == book['bookPurchaseDate'].toDate().month &&
              date.year == book['bookPurchaseDate'].toDate().year) {
            final bool exist = genreList.contains(book['bookGenre']);
            if (!exist) {
              genreList.add(book['bookGenre']);
            }
          }
        }

        if (genreList.isNotEmpty) {
          genreList.insert(0, Strings.statsWholeInventory);
        }
        getLibraryStats(Strings.statsLastMonth, parsedLibraryResponse);
        generateGraphData(Strings.statsLastMonth, parsedLibraryResponse);
      }

      dynamic getCustomGenre(parsedLibraryResponse) {
        if (parsedLibraryResponse.isNotEmpty) {
          final date = DateTime(endDate.year, endDate.month + 1, 0);
          endDate = date;

          for (dynamic book in parsedLibraryResponse) {
            final genreDate = book['bookPurchaseDate'].toDate();

            if (genreDate.isAfter(startDate) && genreDate.isBefore(endDate)) {
              final bool exist = genreList.contains(book['bookGenre']);
              if (!exist) {
                genreList.add(book['bookGenre']);
              }
            }
          }

          if (genreList.isNotEmpty) {
            genreList.insert(0, Strings.statsWholeInventory);
          }
          getLibraryStats(Strings.statsCustom, parsedLibraryResponse);
        }
      }

      switch (value) {
        case Strings.statsAllTime:
          {
            getAllGenre(parsedLibraryResponse);
          }
          break;
        case Strings.statsCurrentYear:
          {
            getCurrentYearGenre(parsedLibraryResponse);
          }
          break;
        case Strings.statsLastYear:
          {
            getLastYearGenre(parsedLibraryResponse);
          }
          break;
        case Strings.statsCurrentMonth:
          {
            getCurrentMonthGenre(parsedLibraryResponse);
          }
          break;
        case Strings.statsLastMonth:
          {
            getLastMonthGenre(parsedLibraryResponse);
          }
          break;
        default:
          {
            getCustomGenre(parsedLibraryResponse);
          }
          break;
      }
    } else {
      genreList = [];
      libraryStats = [];
      spentGraphData = [];
      booksGraphData = [];
    }
  }

  List<String> genreList = [];
  List<dynamic> libraryStats = [];

//  List<String> genreMonthList = [];
  List<String> monthInWord = [];
  List<int> monthlyValueOfGenre = [];
  List<int> monthlyVolumeOfGenre = [];
  List<SubscriberSeries> spentGraphData = [];
  List<SubscriberSeries> booksGraphData = [];
}

class SubscriberSeries {
  const SubscriberSeries(
      {@required this.monthX, @required this.subscribersY, this.barColor});

  final String monthX;
  final int subscribersY;
  final charts.Color barColor;
}
