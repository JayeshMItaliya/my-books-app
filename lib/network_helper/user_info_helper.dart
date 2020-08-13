import 'package:byebye_flutter_app/model/genre.dart';

class UserInfoHelper {
  UserInfoHelper({dynamic parsedUserResponse, dynamic parsedGenreResponse}) {
    int viewed = 0;
    int bookmarked = 0;
    if (parsedUserResponse.isNotEmpty) {
      viewed = parsedUserResponse[0].data['views'];
      bookmarked = parsedUserResponse[0].data['fans'].length;
      userInfo.add(viewed);
      userInfo.add(bookmarked);

      if (parsedGenreResponse.isNotEmpty) {
        for (dynamic genre in parsedGenreResponse) {
          userGenre.add(Genre(
              parsedResponse: genre.data,
              documentId: genre.documentID,
              count: ''));
        }
      }
    }
  }
  var userInfo = [];
  var userGenre = [];
}
