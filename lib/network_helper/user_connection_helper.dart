import 'package:byebye_flutter_app/model/book_lover.dart';

class UserConnectionHelper {
  UserConnectionHelper({dynamic parsedUserResponse, String userId}) {
    int fansCount = 0;
    dynamic userData;

    dynamic getBooksCount(dynamic response) {
      userConnectionList.add(BookLover(
          parsedUserData: response.data,
          bookCount: response['totalBooksVolume'],
          fanCount: fansCount));
    }

    if (parsedUserResponse.isNotEmpty) {
      for (dynamic user in parsedUserResponse) {
        if (user.data['uid'] == userId) {
          userData = user;
        }
      }

      for (int i = 0; i < userData.data['fans'].length; i++) {
        fansCount = 0;
        for (int j = 0; j < parsedUserResponse.length; j++) {
          if (userData.data['fans'][i] == parsedUserResponse[j].data['uid']) {
            fansCount += parsedUserResponse[j].data['fans'].length;
            getBooksCount(parsedUserResponse[j]);
          }
        }
      }
    }
  }

  var userConnectionList = [];
}
