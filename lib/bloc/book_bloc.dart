import 'package:byebye_flutter_app/firebase_repository/firebase_repository.dart';
import 'package:byebye_flutter_app/network_helper/create_book_helper.dart';
import 'package:rxdart/rxdart.dart';

class BookBloc {
  final _firebaseRepository = FirebaseRepository();

  BehaviorSubject<dynamic> aboutBooks = BehaviorSubject<dynamic>();
  BehaviorSubject<dynamic> books = BehaviorSubject<dynamic>();

  Stream<dynamic> get aboutBooksStream => aboutBooks.stream;

  Stream<dynamic> get booksStream => books.stream;

  dynamic aboutUserBooks = [];

  dynamic aboutBook(genreName) async {
    aboutUserBooks = await _firebaseRepository.onGetAboutBooks(genreName);
    aboutBooks.sink.add(aboutUserBooks);
  }

  dynamic booksData = [];
  dynamic testList = [];
  dynamic testListTwo = [];

  dynamic bookList(genreName, tabIndex) async {
    booksData = await _firebaseRepository.onGetBooks(genreName);
    if (tabIndex == 0) {
      testList = booksData.bookList;
      books.sink.add(booksData.bookList);
    } else if (tabIndex == 1) {
      testList = booksData.favouritesList;
      testListTwo = booksData.bookList;
      books.sink.add(booksData.favouritesList);
    } else {
      testList = booksData.regretsList;
      testListTwo = booksData.bookList;
      books.sink.add(booksData.regretsList);
    }
  }

  dynamic readBook(bookId, bookRead) async {
    final dynamic response =
        await _firebaseRepository.onReadBook(bookId, bookRead);
    return response;
  }

  dynamic editBook(
      String bookId, CreateBookHelper createBookHelper, bool imageEdit) async {
    final String bookName = createBookHelper.bookName;
    final String bookGenre = createBookHelper.bookGenre;
    final String bookPrice = createBookHelper.bookPrice;
    final String bookVolumes = createBookHelper.bookVolumes;
    final DateTime bookPurchaseDate = createBookHelper.bookPurchaseDate;
    final dynamic bookPhoto = createBookHelper.bookPhoto;
    final String sellerLink = createBookHelper.sellerLink;
    final String descriptionOfBook = createBookHelper.descriptionOfBook;

    final dynamic response = await _firebaseRepository.onEditBook(
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
    return response;
  }

  dynamic deleteBook(bookId, bookName) async {
    final dynamic response =
        await _firebaseRepository.onDeleteBook(bookId, bookName);
    return response;
  }

  dynamic searchList = [];

  dynamic searchBook(String searchText) {
    searchList = [];
    if (searchText.isEmpty) {
      books.sink.add(testList);
    } else {
      for (int i = 0; i < testList.length; i++) {
        if (testList[i]
            .bookName
            .toLowerCase()
            .contains(searchText.toLowerCase())) {
          searchList.add(testList[i]);
        }
      }
      books.sink.add(searchList);
    }
  }

  dynamic updateRegretOfBook(bookId, bookRegret) async {
    final dynamic response =
        await _firebaseRepository.onUpdateRegret(bookId, bookRegret);
    return response;
  }

  dynamic removeRegretOfBook(bookId) async {
    final dynamic response = await _firebaseRepository.onRemoveRegret(bookId);
    return response;
  }

  dynamic addAndRemoveToFav(bookId, bool favValue) async {
    final dynamic response =
        await _firebaseRepository.onAddAndRemoveToFav(bookId, favValue);
    return response;
  }
}

BookBloc bookBloc = BookBloc();
