import 'package:byebye_flutter_app/firebase_repository/firebase_repository.dart';
import 'package:rxdart/rxdart.dart';

class UserBookBloc {
  final _firebaseRepository = FirebaseRepository();

  BehaviorSubject<dynamic> userGenre = BehaviorSubject<dynamic>();
  BehaviorSubject<dynamic> userBook = BehaviorSubject<dynamic>();

  Stream<dynamic> get userGenreStream => userGenre.stream;

  Stream<dynamic> get userBookStream => userBook.stream;

  dynamic userBooksData = [];

  dynamic userBookList(selectedGenre, userUid) async {
    final dynamic genreList = [];
    final dynamic booksList = [];
    userBooksData =
        await _firebaseRepository.onGetUserBooks(selectedGenre, userUid);
    userBooksData.sortedUserLibrary.forEach((key, value) {
      genreList.add(key);
      booksList.add(value);
    });
    userGenre.sink.add(genreList);
    userBook.sink.add(booksList);
  }
}

UserBookBloc userBookBloc = UserBookBloc();
