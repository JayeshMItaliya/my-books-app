import 'package:byebye_flutter_app/model/book.dart';

class UserBookHelper {
  UserBookHelper({dynamic parsedBookResponse, dynamic parsedGenreResponse}) {
    int count = 0;
    var userBooksList = [];
    final userLibrary = {};
    if (parsedGenreResponse.isNotEmpty) {
      for (int i = 0; i < parsedGenreResponse.length; i++) {
        userBooksList = [];
        count = 0;
        for (int j = 0; j < parsedBookResponse.length; j++) {
          if (parsedGenreResponse[i].data['genreName'] ==
              parsedBookResponse[j].data['bookGenre']) {
            count += int.parse(parsedBookResponse[j].data['bookVolumes']);
            userBooksList.add(Book(responseData: parsedBookResponse[j]));
          }
        }
        if (userBooksList.isNotEmpty) {
          userBooksList.sort((a, b) => a.bookName.compareTo(b.bookName));
          userLibrary['${parsedGenreResponse[i].data['genreName']}*$count'] =
              userBooksList;
        }
      }
      sortedUserLibrary = Map.fromEntries(userLibrary.entries.toList()
        ..sort(
            (e1, e2) => e1.key.toLowerCase().compareTo(e2.key.toLowerCase())));
    }
  }
  var sortedUserLibrary = {};
}
