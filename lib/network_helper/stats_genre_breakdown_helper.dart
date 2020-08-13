import 'package:byebye_flutter_app/model/breakdown_stats.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';

class StatsGenreBreakdownHelper {
  StatsGenreBreakdownHelper(
      {dynamic parsedGenreResponse,
      dynamic parsedLibraryResponse,
      String value,
      DateTime startDate,
      DateTime endDate}) {
    int bookValue = 0;
    int books = 0;
    int monthValueOfGenre = 0;
    int monthValueOfVolume = 0;
    if (parsedGenreResponse.isNotEmpty) {
      //To calculate library stats.
      dynamic getLibraryStats(interval, genreList, parsedLibraryResponse) {
        final date = DateTime.now();
        int time = 0;
        int year = 0;
        libraryStats = [];
        bookValue = 0;
        books = 0;

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
          case 'Custom':
            {
              time = 0;
            }
            break;
        }

        for (dynamic genre in genreList) {
          for (dynamic book in parsedLibraryResponse) {
            if (genre == book['bookGenre']) {
              if (interval == 'Current Year' || interval == 'Last Year') {
                if (time == book['bookPurchaseDate'].toDate().year) {
                  bookValue += int.parse(book['bookPrice']);
                  books += int.parse(book['bookVolumes']);
                }
              } else if (interval == 'Current Month' ||
                  interval == 'Last Month') {
                if (year == book['bookPurchaseDate'].toDate().year &&
                    time == book['bookPurchaseDate'].toDate().month) {
                  bookValue += int.parse(book['bookPrice']);
                  books += int.parse(book['bookVolumes']);
                }
              } else {
                final date = DateTime(endDate.year, endDate.month + 1, 0);
                endDate = date;
                final purchaseDate = book['bookPurchaseDate'].toDate();
                if (startDate.month == endDate.month) {
                  if (purchaseDate.year == startDate.year &&
                      purchaseDate.year == endDate.year &&
                      purchaseDate.month == startDate.month &&
                      purchaseDate.month == endDate.month) {
                    bookValue += int.parse(book['bookPrice']);
                    books += int.parse(book['bookVolumes']);
                  }
                } else {
                  if (purchaseDate.isAfter(startDate) &&
                      purchaseDate.isBefore(endDate)) {
                    bookValue += int.parse(book['bookPrice']);
                    books += int.parse(book['bookVolumes']);
                  }
                }
              }
            }
          }
        }
        libraryStats.add(BreakdownStats(
          value: bookValue,
          book: books,
        ));
      }

      //To Generate Graph Data.
      dynamic generateGraphData(genreList, parsedLibraryResponse,
          {String interval}) {
        final date = DateTime.now();
        int time = 0;
        int year = 0;
        final RandomColor randomColor = RandomColor();

        switch (interval) {
          case 'All Time':
            {
              time = 0;
            }
            break;
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

        for (String genre in genreList) {
          monthValueOfGenre = 0;
          monthValueOfVolume = 0;
          for (dynamic book in parsedLibraryResponse) {
            if (genre == book['bookGenre']) {
              if (interval == 'Current Year' || interval == 'Last Year') {
                if (time == book['bookPurchaseDate'].toDate().year) {
                  monthValueOfGenre += int.parse(book['bookPrice']);
                  monthValueOfVolume += int.parse(book['bookVolumes']);
                }
              } else if (interval == 'Current Month' ||
                  interval == 'Last Month') {
                if (time == book['bookPurchaseDate'].toDate().month &&
                    year == book['bookPurchaseDate'].toDate().year) {
                  monthValueOfGenre += int.parse(book['bookPrice']);
                  monthValueOfVolume += int.parse(book['bookVolumes']);
                }
              } else if (time == 0) {
                monthValueOfGenre += int.parse(book['bookPrice']);
                monthValueOfVolume += int.parse(book['bookVolumes']);
              } else {
                final date = DateTime(endDate.year, endDate.month + 1, 0);
                endDate = date;
                final purchaseDate = book['bookPurchaseDate'].toDate();
                if (purchaseDate.isAfter(startDate) &&
                    purchaseDate.isBefore(endDate)) {
                  monthValueOfGenre += int.parse(book['bookPrice']);
                  monthValueOfVolume += int.parse(book['bookVolumes']);
                }
              }
            }
          }
          monthlyValueOfGenre.add(monthValueOfGenre);
          monthlyVolumeOfGenre.add(monthValueOfVolume);
        }

        for (int i = 0; i < monthlyValueOfGenre.length; i++) {
          if (monthlyValueOfGenre[i] != 0) {
            final Color _color =
                randomColor.randomColor(colorHue: ColorHue.red);
            spentGraphData.add(SubscriberSeries(
              genreNameX: genreList[i],
              subscribersY: monthlyValueOfGenre[i],
              pieArchColor: charts.ColorUtil.fromDartColor(_color),
              color: _color,
            ));
          }
        }

        for (int i = 0; i < monthlyVolumeOfGenre.length; i++) {
          if (monthlyVolumeOfGenre[i] != 0) {
            final Color _color =
                randomColor.randomColor(colorHue: ColorHue.red);
            booksGraphData.add(SubscriberSeries(
              genreNameX: genreList[i],
              subscribersY: monthlyVolumeOfGenre[i],
              pieArchColor: charts.ColorUtil.fromDartColor(_color),
              color: _color,
            ));
          }
        }
      }

      dynamic getAllGenre(parsedGenreResponse, parsedLibraryResponse) {
        genreList = [];
        libraryStats = [];
        bookValue = 0;
        books = 0;
        for (dynamic book in parsedLibraryResponse) {
          final bool exist = genreList.contains(book['bookGenre']);
          if (!exist) {
            genreList.add(book['bookGenre']);
          }
        }

        for (dynamic book in parsedLibraryResponse) {
          bookValue += int.parse(book['bookPrice']);
          books += int.parse(book['bookVolumes']);
        }
        generateGraphData(genreList, parsedLibraryResponse,
            interval: 'All Time');

        libraryStats.add(BreakdownStats(
          value: bookValue,
          book: books,
        ));
      }

      dynamic getCurrentYearGenre(parsedGenreResponse, parsedLibraryResponse) {
        final DateTime date = DateTime.now();
        genreList = [];
        libraryStats = [];
        bookValue = 0;
        books = 0;

        for (dynamic book in parsedLibraryResponse) {
          if (date.year == book['bookPurchaseDate'].toDate().year) {
            final bool exist = genreList.contains(book['bookGenre']);
            if (!exist) {
              genreList.add(book['bookGenre']);
            }
          }
        }

        generateGraphData(genreList, parsedLibraryResponse,
            interval: 'Current Year');
        getLibraryStats('Current Year', genreList, parsedLibraryResponse);
      }

      dynamic getLastYearGenre(parsedGenreResponse, parsedLibraryResponse) {
        final DateTime date = DateTime.now();
        genreList = [];
        libraryStats = [];
        bookValue = 0;
        books = 0;
        for (dynamic book in parsedLibraryResponse) {
          if (date.year - 1 == book['bookPurchaseDate'].toDate().year) {
            final bool exist = genreList.contains(book['bookGenre']);
            if (!exist) {
              genreList.add(book['bookGenre']);
            }
          }
        }
        generateGraphData(genreList, parsedLibraryResponse,
            interval: 'Last Year');
        getLibraryStats('Last Year', genreList, parsedLibraryResponse);
      }

      dynamic getCurrentMonthGenre(parsedGenreResponse, parsedLibraryResponse) {
        final DateTime date = DateTime.now();
        genreList = [];
        libraryStats = [];
        bookValue = 0;
        books = 0;
        for (dynamic book in parsedLibraryResponse) {
          if (date.month == book['bookPurchaseDate'].toDate().month) {
            final bool exist = genreList.contains(book['bookGenre']);
            if (!exist) {
              genreList.add(book['bookGenre']);
            }
          }
        }
        generateGraphData(genreList, parsedLibraryResponse,
            interval: 'Current Month');
        getLibraryStats('Current Month', genreList, parsedLibraryResponse);
      }

      dynamic getLastMonthGenre(parsedGenreResponse, parsedLibraryResponse) {
        final DateTime date = DateTime.now();
        genreList = [];
        libraryStats = [];
        bookValue = 0;
        books = 0;
        for (dynamic book in parsedLibraryResponse) {
          if (date.month - 1 == book['bookPurchaseDate'].toDate().month) {
            final bool exist = genreList.contains(book['bookGenre']);
            if (!exist) {
              genreList.add(book['bookGenre']);
            }
          }
        }

        generateGraphData(genreList, parsedLibraryResponse,
            interval: 'Last Month');
        getLibraryStats('Last Month', genreList, parsedLibraryResponse);
      }

      dynamic getCustomGenre(parsedGenreResponse, parsedLibraryResponse) {
        if (parsedGenreResponse.isNotEmpty) {
          final date = DateTime(endDate.year, endDate.month + 1, 0);
          endDate = date;
          for (dynamic book in parsedLibraryResponse) {
            final purchaseDate = book['bookPurchaseDate'].toDate();

            if (purchaseDate.isAfter(startDate) &&
                purchaseDate.isBefore(endDate)) {
              final bool exist = genreList.contains(book['bookGenre']);
              if (!exist) {
                genreList.add(book['bookGenre']);
              }
            }
          }
          getLibraryStats('Custom', genreList, parsedLibraryResponse);
//          generateGraphData(genreList, parsedLibraryResponse,
//              interval: 'Custom');
        }
      }

      switch (value) {
        case 'All Time':
          {
            getAllGenre(parsedGenreResponse, parsedLibraryResponse);
          }
          break;
        case 'Current Year':
          {
            getCurrentYearGenre(parsedGenreResponse, parsedLibraryResponse);
          }
          break;
        case 'Last Year':
          {
            getLastYearGenre(parsedGenreResponse, parsedLibraryResponse);
          }
          break;
        case 'Current Month':
          {
            getCurrentMonthGenre(parsedGenreResponse, parsedLibraryResponse);
          }
          break;
        case 'Last Month':
          {
            getLastMonthGenre(parsedGenreResponse, parsedLibraryResponse);
          }
          break;
        case 'Custom':
          {
            getCustomGenre(parsedGenreResponse, parsedLibraryResponse);
          }
          break;
      }
    }
  }

  List<String> genreList = [];
  List<dynamic> libraryStats = [];
  List<int> monthlyValueOfGenre = [];
  List<int> monthlyVolumeOfGenre = [];
  List<SubscriberSeries> spentGraphData = [];
  List<SubscriberSeries> booksGraphData = [];
}

class SubscriberSeries {
  const SubscriberSeries(
      {@required this.genreNameX,
      @required this.subscribersY,
      @required this.pieArchColor,
      this.color});

  final String genreNameX;
  final int subscribersY;
  final charts.Color pieArchColor;
  final Color color;
}
