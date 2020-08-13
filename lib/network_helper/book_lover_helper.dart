import 'package:byebye_flutter_app/model/book_lover.dart';
import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookLoverHelper {
  BookLoverHelper(
      {dynamic parsedUserResponse,
      QuerySnapshot lastBookLoverData,
      QuerySnapshot lastActiveBookLoverData}) {
    int fansCount = 0;

    if (parsedUserResponse.isNotEmpty) {
      for (int i = 0; i < parsedUserResponse.length; i++) {
        fansCount = 0;
        fansCount += parsedUserResponse[i].data['fans'].length;

        if (parsedUserResponse[i]
            .data['fans']
            .contains(prefsObject.getString('uid'))) {
          bookmarkedList.add(BookLover(
              parsedUserData: parsedUserResponse[i].data,
              bookCount: parsedUserResponse[i].data['totalBooksVolume'] ?? 0,
              fanCount: fansCount,
              userStatus: userPresence(parsedUserResponse[i]),
              color: badgeColorSetter(parsedUserResponse[i])));
        }
        allBookLoverList.add(BookLover(
            parsedUserData: parsedUserResponse[i].data,
            bookCount: parsedUserResponse[i].data['totalBooksVolume'] ?? 0,
            fanCount: fansCount,
            userStatus: userPresence(parsedUserResponse[i]),
            color: badgeColorSetter(parsedUserResponse[i])));
        if (parsedUserResponse[i].data['totalBooksVolume'] != 6 &&
            parsedUserResponse[i].data['totalBooksPrice'] != 53) {
          activeBookLoverList.add(BookLover(
              parsedUserData: parsedUserResponse[i].data,
              bookCount: parsedUserResponse[i].data['totalBooksVolume'] ?? 0,
              fanCount: fansCount,
              userStatus: userPresence(parsedUserResponse[i]),
              color: badgeColorSetter(parsedUserResponse[i])));
        }
      }
      if (lastBookLoverData != null) {
        previousBookLoverData.addAll(lastBookLoverData.documents);
      } else if (lastActiveBookLoverData != null) {
        previousActiveBookLoverData.addAll(lastActiveBookLoverData.documents);
      }

      allBookLoverList
          .removeWhere((item) => item.userUid == prefsObject.getString('uid'));
      allBookLoverList.removeWhere(
          (item) => item.blockList.contains(prefsObject.getString('uid')));

      activeBookLoverList
          .removeWhere((item) => item.userUid == prefsObject.getString('uid'));
      activeBookLoverList.removeWhere(
          (item) => item.blockList.contains(prefsObject.getString('uid')));

      bookmarkedList
          .removeWhere((item) => item.userUid == prefsObject.getString('uid'));
      bookmarkedList.removeWhere(
          (item) => item.blockList.contains(prefsObject.getString('uid')));
    }
  }

  var previousBookLoverData = [];
  var previousActiveBookLoverData = [];
  var allBookLoverList = [];
  var activeBookLoverList = [];
  var bookmarkedList = [];
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
                ? "ACTIVE TODAY (${different.inHours} ${different.inHours == 1 ? "HR" : "HRS"})"
                : different.inMinutes > 0 && ts.day == DateTime.now().day
                    ? "ACTIVE TODAY (${different.inMinutes} ${different.inMinutes == 1 ? "MIN" : "MIN"})"
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
