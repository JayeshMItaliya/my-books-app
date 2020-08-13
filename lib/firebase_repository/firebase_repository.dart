import 'package:byebye_flutter_app/firebase_provider/notification_provider.dart';
import 'package:byebye_flutter_app/firebase_provider/people_filter_provider.dart';
import 'package:byebye_flutter_app/firebase_provider/specific_genre_breakdown_provider.dart';
import 'package:byebye_flutter_app/firebase_provider/specific_genre_provider.dart';
import 'package:byebye_flutter_app/firebase_provider/specific_genre_stats_provider.dart';
//import 'package:byebye_flutter_app/firebase_provider/user_demo_provider.dart';
import 'package:byebye_flutter_app/firebase_provider/user_info_provider.dart';
import 'package:byebye_flutter_app/firebase_provider/about_books.dart';
import 'package:byebye_flutter_app/firebase_provider/about_genres.dart';
import 'package:byebye_flutter_app/firebase_provider/add_new_book_provider.dart';
import 'package:byebye_flutter_app/firebase_provider/add_genre_provider.dart';
import 'package:byebye_flutter_app/firebase_provider/book_lovers_provider.dart';
import 'package:byebye_flutter_app/firebase_provider/book_provider.dart';
import 'package:byebye_flutter_app/firebase_provider/genre_provider.dart';
import 'package:byebye_flutter_app/firebase_provider/library_status_provider.dart';
import 'package:byebye_flutter_app/firebase_provider/user_book_provider.dart';
import 'package:byebye_flutter_app/firebase_provider/user_connection_provider.dart';
import 'package:byebye_flutter_app/firebase_provider/user_genre_provider.dart';
import 'package:byebye_flutter_app/firebase_provider/user_stats_monthly_filter_provider.dart';
import 'package:byebye_flutter_app/network_helper/about_user_book_helper.dart';
import 'package:byebye_flutter_app/network_helper/about_user_genre_helper.dart';
import 'package:byebye_flutter_app/network_helper/book_helper.dart';
import 'package:byebye_flutter_app/network_helper/book_lover_helper.dart';
import 'package:byebye_flutter_app/network_helper/genre_helper.dart';
import 'package:byebye_flutter_app/network_helper/highlight_book_lover_helper.dart';
import 'package:byebye_flutter_app/network_helper/notification_helper.dart';
import 'package:byebye_flutter_app/network_helper/people_filter_helper.dart';
import 'package:byebye_flutter_app/network_helper/specific_stats_genre_helper.dart';
import 'package:byebye_flutter_app/network_helper/stats_genre_breakdown_helper.dart';
import 'package:byebye_flutter_app/network_helper/stats_genre_helper.dart';
import 'package:byebye_flutter_app/network_helper/user_book_helper.dart';
import 'package:byebye_flutter_app/network_helper/user_connection_helper.dart';
import 'package:byebye_flutter_app/network_helper/user_info_helper.dart';
import 'package:byebye_flutter_app/network_helper/user_specific_stats_helper.dart';

class FirebaseRepository {
  final _userInfoProvider = UserInfoProvider();
  final _aboutGenres = AboutGenres();
  final _aboutBooks = AboutBooks();
  final _addGenreProvider = AddGenreProvider();
  final _genreProvider = GenreProvider();
  final _bookProvider = BookProvider();
  final _addNewBookProvider = AddNewBook();
  final _bookLoversProvider = BookLoversProvider();
  final _userGenreProvider = UserGenreProvider();
  final _userBookProvider = UserBookProvider();
  final _userConnectionProvider = UserConnectionProvider();
  final _libraryStatusProvider = LibraryStatusProvider();
  final _specificGenreProvider = SpecificGenreProvider();
  final _specificGenreStatsProvider = SpecificGenreStatsProvider();
  final _specificGenreBreakdown = SpecificGenreBreakdown();
  ///This functionality commented because we don't require we change it to simple text note.
//  final _userDemoProvider = UserDemoProvider();
  final _specificPeopleFilterProvider = SpecificPeopleFilterProvider();
  final _specificMonthlyStatsProvider = SpecificMonthlyStatsProvider();
  final _notificationProvider = NotificationProvider();

  Future<AboutUserGenreHelper> onGetAboutGenres() =>
      _aboutGenres.onGetAboutGenresApi();

  Future<dynamic> addNewGenre(String genreName) =>
      _addGenreProvider.addNewGenreApi(genreName);

  Future<GenreHelper> onGetGenre(String userUid) =>
      _genreProvider.onGetGenreApi(userUid);

  Future<dynamic> onEditGenre(
          String genreName, String oldGenreName, String genreId) =>
      _genreProvider.onEditGenreApi(genreName, oldGenreName, genreId);

  Future<dynamic> onDeleteGenre(String genreName, String genreId) =>
      _genreProvider.onDeleteGenreApi(genreName, genreId);

  Future<AboutUserBookHelper> onGetAboutBooks(String genreName) =>
      _aboutBooks.onGetAboutBooksApi(genreName);

  Future<BookHelper> onGetBooks(genreName) =>
      _bookProvider.onGetBookApi(genreName);

  Future<dynamic> onReadBook(bookId, bookRead) =>
      _bookProvider.onReadBookApi(bookId, bookRead);

  Future<dynamic> onDeleteBook(bookId, bookName) =>
      _bookProvider.onDeleteBookApi(bookId, bookName);

  Future<dynamic> onAddAndRemoveToFav(bookId, favValue) =>
      _bookProvider.onAddAndRemoveToFavApi(bookId, favValue);

  Future<dynamic> onUpdateRegret(bookId, bookRegret) =>
      _bookProvider.onUpdateRegretApi(bookId, bookRegret);

  Future<dynamic> onRemoveRegret(bookId) =>
      _bookProvider.onRemoveRegretApi(bookId);

  Future<dynamic> addNewBook(
    String bookName,
    String bookGenre,
    String bookPrice,
    String bookVolumes,
    DateTime bookPurchaseDate,
    dynamic bookPhoto,
    String sellerLink,
    String descriptionOfBook,
  ) =>
      _addNewBookProvider.addNewBookApi(
        bookName,
        bookGenre,
        bookPrice,
        bookVolumes,
        bookPurchaseDate,
        bookPhoto,
        sellerLink,
        descriptionOfBook,
      );

  Future<dynamic> onEditBook(
          String bookId,
          String bookName,
          String bookGenre,
          String bookPrice,
          String bookVolumes,
          DateTime bookPurchaseDate,
          dynamic bookPhoto,
          String sellerLink,
          String descriptionOfBook,
          bool imageEdit) =>
      _bookProvider.onEditBookApi(
        bookId,
        bookName,
        bookGenre,
        bookPrice,
        bookVolumes,
        bookPurchaseDate,
        bookPhoto,
        sellerLink,
        descriptionOfBook,
        imageEdit,
      );

  Future<BookLoverHelper> onGetAllBookLovers() =>
      _bookLoversProvider.onGetAllBookLoversApi();

  Future<BookLoverHelper> onGetBookLovers() =>
      _bookLoversProvider.onGetBookLoversApi();

  Future<BookLoverHelper> onGetNextBookLovers(dynamic documentList) =>
      _bookLoversProvider.onGetNextBookLoversApi(documentList);

  Future<BookLoverHelper> onGetActiveBookLovers() =>
      _bookLoversProvider.onGetActiveBookLoversApi();

  Future<BookLoverHelper> onGetNextActiveBookLovers(dynamic documentList) =>
      _bookLoversProvider.onGetNextActiveBookLoversApi(documentList);

  Future<HighLightBookLoverHelper> onGetHighLightUser() =>
      _bookLoversProvider.onGetHighLightUserApi();

  Future<dynamic> onAddAndRemoveToBookmarked(String userId, bookmarkedValue) =>
      _bookLoversProvider.onAddAndRemoveToBookmarkedApi(
          userId, bookmarkedValue);

  Future<dynamic> onAddUserViewCount(String userId, int views) =>
      _bookLoversProvider.onAddUserViewCountApi(userId, views);

  Future<dynamic> onGetUserGenre(String userUid) =>
      _userGenreProvider.onGetUserGenreApi(userUid);

  Future<dynamic> onBlockUser(String userUid) =>
      _userGenreProvider.onBlockUserApi(userUid);

  Future<UserBookHelper> onGetUserBooks(String genreName, String userUid) =>
      _userBookProvider.onGetUserBooksApi(genreName, userUid);

  Future<UserConnectionHelper> onGetUserConnectionList(String userUid) =>
      _userConnectionProvider.onGetUserConnectionListApi(userUid);

  Future<dynamic> onGetLibraryStatus() =>
      _libraryStatusProvider.onGetLibraryStatusApi();

  Future<dynamic> onChangeLibraryStatus(bool status) =>
      _libraryStatusProvider.onChangeLibraryStatusApi(status);

  Future<UserInfoHelper> onGetUserLibraryInfo(String userId) =>
      _userInfoProvider.onGetUserLibraryInfoApi(userId);

  Future<StatsGenreHelper> onGetSpecificGenre(uid,
          {DateTime startDate, DateTime endDate, String value}) =>
      _specificGenreProvider.onGetSpecificGenreApi(uid,
          value: value, startDate: startDate, endDate: endDate);

  Future<SpecificStatsGenreHelper> onGetSpecificGenreStats(
          String genre, String uid,
          {String timePeriod, DateTime startDate, DateTime endDate}) =>
      _specificGenreStatsProvider.onGetSpecificGenreStatsApi(genre, uid,
          timePeriod: timePeriod, startDate: startDate, endDate: endDate);

  Future<StatsGenreBreakdownHelper> onGetSpecificGenreBreakdown(uid,
          {DateTime startDate, DateTime endDate, String value}) =>
      _specificGenreBreakdown.onGetSpecificGenreBreakdownApi(uid,
          value: value, startDate: startDate, endDate: endDate);

  ///This functionality commented because we don't require we change it to simple text note.
//  Future<bool> addDemoGenre(uid) => _userDemoProvider.addDemoGenreApi(uid);

  //People filter

  Future<PeopleFilterHelper> onGetSpecificFilter(
          {String genderValue,
          String ageValue,
          String inventoryVal,
          String activityVal}) =>
      _specificPeopleFilterProvider.onGetSpecificFilterApi(
        genderValue: genderValue,
        ageValue: ageValue,
        inventoryVal: inventoryVal,
        activityVal: activityVal,
      );

  Future<StatsFilterMonthlyHelper> onGetMonthlyStats(
          {DateTime selectedMonth, String monthlyValue}) =>
      _specificMonthlyStatsProvider.onGetMonthlyStatsApi(
        selectedMonth: selectedMonth,
        monthlyVal: monthlyValue,
      );

  //Notification Inbox

  Future<NotificationHelper> onGetNotification() =>
      _notificationProvider.notificationApi();
}
