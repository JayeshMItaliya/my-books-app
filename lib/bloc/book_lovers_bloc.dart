import 'package:byebye_flutter_app/firebase_repository/firebase_repository.dart';
import 'package:rxdart/rxdart.dart';

class BookLoversBloc {
  final _firebaseRepository = FirebaseRepository();

  BehaviorSubject<List> allBookLover = BehaviorSubject<List>();
  BehaviorSubject<dynamic> activeBookLover = BehaviorSubject<dynamic>();
  BehaviorSubject<dynamic> followBookLover = BehaviorSubject<dynamic>();
  BehaviorSubject<dynamic> highLightBookLover = BehaviorSubject<dynamic>();

  Stream<List<dynamic>> get allBookLoversStream => allBookLover.stream;
  Stream<dynamic> get activeBookLoverStream => activeBookLover.stream;
  Stream<dynamic> get followBookLoverStream => followBookLover.stream;
  Stream<dynamic> get highLightBookLoversStream => highLightBookLover.stream;

  dynamic bookLoversData = [];
  dynamic totalBookLoversData = [];
  dynamic activeBookLoversData = [];
  dynamic totalActiveBookLoverData = [];
  dynamic testListAll = [];
  dynamic testListActive = [];
  dynamic testListFollow = [];

  dynamic allbookLoversList(tabIndex) async {
    bookLoversData = await _firebaseRepository.onGetAllBookLovers();
    if (tabIndex == 0) {
      testListAll = bookLoversData.allBookLoverList;
      testListActive = bookLoversData.activeBookLoverList;
    } else if (tabIndex == 1) {
      testListFollow = bookLoversData.bookmarkedList;
      followBookLover.sink.add(bookLoversData.bookmarkedList);
    }
  }

  dynamic bookLoversList(tabIndex) async {
    bookLoversData = await _firebaseRepository.onGetBookLovers();
    if (tabIndex == 0) {
      totalBookLoversData = bookLoversData.previousBookLoverData;
      allBookLover.sink.add(bookLoversData.allBookLoverList);
    }
  }

  dynamic nextBookLoversList(tabIndex) async {
    bookLoversData =
        await _firebaseRepository.onGetNextBookLovers(totalBookLoversData);
    if (bookLoversData != null) {
      totalBookLoversData =
          totalBookLoversData + bookLoversData.previousBookLoverData;
      if (tabIndex == 0) {
        allBookLover.sink
            .add(allBookLover.value + bookLoversData.allBookLoverList);
      }
    }
  }

  dynamic activeBookLoversList(tabIndex) async {
    activeBookLoversData = await _firebaseRepository.onGetActiveBookLovers();
    if (tabIndex == 0 && activeBookLoversData != null) {
      testListActive = activeBookLoversData.activeBookLoverList;
      totalActiveBookLoverData =
          activeBookLoversData.previousActiveBookLoverData;
      activeBookLover.sink.add(activeBookLoversData.activeBookLoverList);
    }
  }

  dynamic nextActiveBookLoversList(tabIndex) async {
    activeBookLoversData = await _firebaseRepository
        .onGetNextActiveBookLovers(totalActiveBookLoverData);

    if (activeBookLoversData != null) {
      totalActiveBookLoverData = totalActiveBookLoverData +
          activeBookLoversData.previousActiveBookLoverData;

      if (tabIndex == 0) {
        activeBookLover.sink.add(
            activeBookLover.value + activeBookLoversData.activeBookLoverList);
      }
    }
  }

  dynamic highLightUser() async {
    final dynamic highLightData =
        await _firebaseRepository.onGetHighLightUser();
    highLightBookLover.sink.add(highLightData.highlightBookLovers);
  }

  dynamic searchList = [];

  dynamic searchUser(String searchText, int index, {bool value}) async {
    searchList = [];
    if (searchText.isEmpty) {
      if (index == 0 && value) {
        activeBookLover.sink.add(testListActive);
      } else if (index == 0 && !value) {
        allBookLover.sink.add(testListAll);
      } else {
        followBookLover.sink.add(testListFollow);
      }
    } else {
      if (index == 0 && value) {
        for (int i = 0; i < testListActive.length; i++) {
          if (testListActive[i]
              .userName
              .toLowerCase()
              .contains(searchText.toLowerCase())) {
            searchList.add(testListActive[i]);
          }
        }
        activeBookLover.sink.add(searchList);
      } else if (index == 0 && !value) {
        for (int i = 0; i < testListAll.length; i++) {
          if (testListAll[i]
              .userName
              .toLowerCase()
              .contains(searchText.toLowerCase())) {
            searchList.add(testListAll[i]);
          }
        }
        allBookLover.sink.add(searchList);
      } else {
        for (int i = 0; i < testListFollow.length; i++) {
          if (testListFollow[i]
              .userName
              .toLowerCase()
              .contains(searchText.toLowerCase())) {
            searchList.add(testListFollow[i]);
          }
        }
        followBookLover.sink.add(searchList);
      }
    }
  }

  dynamic addAndRemoveToBookmarked(userId, bool bookmarkedValue) async {
    final dynamic response = await _firebaseRepository
        .onAddAndRemoveToBookmarked(userId, bookmarkedValue);
    return response;
  }

  dynamic addUserViewCount(userId, views) async {
    final dynamic response =
        await _firebaseRepository.onAddUserViewCount(userId, views);
    return response;
  }
}

BookLoversBloc bookLoversBloc = BookLoversBloc();
