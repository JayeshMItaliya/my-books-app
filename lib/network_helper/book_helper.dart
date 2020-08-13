import 'package:byebye_flutter_app/model/book.dart';

class BookHelper {
  BookHelper({dynamic parsedBookResponse}) {
    if (parsedBookResponse.isNotEmpty) {
      for (dynamic book in parsedBookResponse) {
        bookList.add(Book(responseData: book));

        if (book.data['favourite']) {
          favouritesList.add(Book(responseData: book));
        }
        if (book.data['regretOfBook'] != '') {
          regretsList.add(Book(responseData: book));
        }
      }
      bookList.sort((a, b) =>
          a.bookName.toLowerCase().compareTo(b.bookName.toLowerCase()));
      favouritesList.sort((a, b) =>
          a.bookName.toLowerCase().compareTo(b.bookName.toLowerCase()));
      regretsList.sort((a, b) =>
          a.bookName.toLowerCase().compareTo(b.bookName.toLowerCase()));
    }
  }

  var bookList = [];
  var favouritesList = [];
  var regretsList = [];
}
