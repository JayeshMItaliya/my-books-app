import 'package:byebye_flutter_app/bloc/user_stats_monthly_bloc.dart';
import 'package:byebye_flutter_app/constants/strings.dart';
import 'package:byebye_flutter_app/model/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List currentUserBooks = [];
DateTime currentTime = DateTime.now();
Timestamp purchaseTimeStamp;
DateTime purchasedOn;

class StatsFilterMonthlyHelper {
  StatsFilterMonthlyHelper({
    dynamic parsedLibraryResponse,
    DateTime selectedMonth,
    String monthlyValue,
  }) {
    if (monthlyValue != null) {
      switch (monthlyValue) {
        case Strings.statsCurrentMonth:
          {
            currentMonthUserBook(parsedLibraryResponse, monthlyValue);
          }
          break;
        case Strings.statsLastMonth:
          {
            lastMonthUserBook(parsedLibraryResponse, monthlyValue);
          }
          break;
        case Strings.statsCustom:
          {
            customMonthUserBook(
                parsedLibraryResponse, selectedMonth, monthlyValue);
          }
          break;
      }
    }
  }
  dynamic defaultUserBook(parsedLibraryResponse, value) {
    currentUserBooks = [];
    if (parsedLibraryResponse.isNotEmpty) {
      parsedLibraryResponse.forEach((books) {
        currentUserBooks.add(Book(responseData: books));
      });
      userStatsMonthlyBloc.updateSelectedFilterData(currentUserBooks);
    }
  }

  dynamic currentMonthUserBook(parsedLibraryResponse, value) {
    currentUserBooks = [];
    if (parsedLibraryResponse.isNotEmpty) {
      parsedLibraryResponse.forEach((books) {
        purchaseTimeStamp = books.data['bookPurchaseDate'];
        purchasedOn = purchaseTimeStamp.toDate();
        if (purchasedOn.year == currentTime.year &&
            purchasedOn.month == currentTime.month) {
          currentUserBooks.add(Book(responseData: books));
        }
      });
      userStatsMonthlyBloc.updateSelectedFilterData(currentUserBooks);
    }
  }

  dynamic lastMonthUserBook(parsedLibraryResponse, value) {
    currentUserBooks = [];
    if (parsedLibraryResponse.isNotEmpty) {
      parsedLibraryResponse.forEach((books) {
        purchaseTimeStamp = books.data['bookPurchaseDate'];
        purchasedOn = purchaseTimeStamp.toDate();
        if (purchasedOn.year == currentTime.year &&
            purchasedOn.month == currentTime.month - 1) {
          currentUserBooks.add(Book(responseData: books));
        }
      });
      userStatsMonthlyBloc.updateSelectedFilterData(currentUserBooks);
    }
  }

  dynamic customMonthUserBook(parsedLibraryResponse, selectedMonth, value) {
    currentUserBooks = [];
    if (parsedLibraryResponse.isNotEmpty) {
      parsedLibraryResponse.forEach((books) {
        purchaseTimeStamp = books.data['bookPurchaseDate'];
        purchasedOn = purchaseTimeStamp.toDate();
        if (purchasedOn.year == selectedMonth.year &&
            purchasedOn.month == selectedMonth.month) {
          currentUserBooks.add(Book(responseData: books));
        }
      });
      userStatsMonthlyBloc.updateSelectedFilterData(currentUserBooks);
    }
  }
}
