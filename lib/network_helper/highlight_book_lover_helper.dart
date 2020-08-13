import 'package:byebye_flutter_app/model/book_lover.dart';
import 'package:byebye_flutter_app/my_constants/design_system.dart';

class HighLightBookLoverHelper {
  HighLightBookLoverHelper({dynamic parsedUserResponse}) {
    int fansCount = 0;
    var bookLoverList = [];
    var highlightTopTen = [];

    if (parsedUserResponse.isNotEmpty) {
      bookLoverList = [];
      for (int i = 0; i < parsedUserResponse.length; i++) {
        fansCount = 0;
        fansCount += parsedUserResponse[i].data['fans'].length;

        if (parsedUserResponse[i]
            .data['fans']
            .contains(prefsObject.getString('uid'))) {
          bookLoverList.add(BookLover(
            parsedUserData: parsedUserResponse[i].data,
            bookCount: parsedUserResponse[i].data['totalBooksVolume'],
            fanCount: fansCount,
            userStatus: userPresence(parsedUserResponse[i]),
            color: badgeColorSetter(parsedUserResponse[i]),
          ));
        } else {
          bookLoverList.add(BookLover(
            parsedUserData: parsedUserResponse[i].data,
            bookCount: parsedUserResponse[i].data['totalBooksVolume'],
            fanCount: fansCount,
            userStatus: userPresence(parsedUserResponse[i]),
            color: badgeColorSetter(parsedUserResponse[i]),
          ));
        }
      }
    }
    bookLoverList.sort((b, a) => a.fansCount.compareTo(b.fansCount));
    bookLoverList.removeWhere(
        (item) => item.blockList.contains(prefsObject.getString('uid')));

    if (bookLoverList.length > 10) {
      highlightTopTen = bookLoverList.sublist(0, 10);
      highlightBookLovers = highlightTopTen;
    } else {
      highlightBookLovers = bookLoverList;
    }
  }

  var highlightBookLovers = [];
}

String userPresence(dynamic response) {
  if (response.data.containsKey('activeTime')) {
    final DateTime ts = response.data['activeTime'].toDate();
    final different = DateTime.now().difference(ts);
    final currentHr = DateTime.now().hour;
    final activeStatusHr = ts.hour;

    return different.inDays > 0
        ? "ACTIVE ${different.inDays} ${different.inDays == 1 ? "DAY" : "DAYS"} AGO"
        : currentHr.compareTo(activeStatusHr) < 24 &&
                ts.day != DateTime.now().day
            ? 'ACTIVE 1 DAY AGO'
            : different.inHours > 0 && ts.day == DateTime.now().day
                ? "ACTIVE TODAY (${different.inHours} ${different.inHours == 1 ? "HR" : "HR"})"
                : different.inMinutes > 0 && ts.day == DateTime.now().day
                    ? "ACTIVE TODAY (${different.inMinutes} ${different.inMinutes == 1 ? "MIN" : "M"})"
                    : different.inMinutes == 0 ? 'ACTIVE NOW' : '';
  } else {
    return 'APP NOT UPDATED YET';
  }
}

int badgeColorSetter(dynamic response) {
  if (response.data.containsKey('activeTime')) {
    final DateTime ts = response.data['activeTime'].toDate();
    final different = DateTime.now().difference(ts);
    final currentHr = DateTime.now().hour;
    final activeStatusHr = ts.hour;
    return different.inDays > 0
        ? 3
        : currentHr.compareTo(activeStatusHr) < 24 &&
                ts.day != DateTime.now().day
            ? 3
            : different.inHours > 0
                ? 2
                : different.inMinutes > 0
                    ? 2
                    : different.inMinutes == 0 ? 1 : 1;
  } else {
    return 4;
  }
}
