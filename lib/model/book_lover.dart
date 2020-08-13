class BookLover {
  BookLover(
      {dynamic parsedUserData,
      int bookCount,
      int fanCount,
      String userStatus,
      int color}) {
    userName = parsedUserData['name'];
    userEmail = parsedUserData['emailId'];
    userUid = parsedUserData['uid'];
    userPhoto = parsedUserData['photoUrl'];
    userSince = parsedUserData['createdOn'].toDate().toString();
    location = parsedUserData['location'];
    gender = parsedUserData['gender'];
    age = parsedUserData['age'];
    workingIn = parsedUserData['workingIn'];
    userStory = parsedUserData['userStory'];
    booksCount = bookCount;
    fansCount = fanCount;
    views = parsedUserData['views'];
    status = userStatus ?? '';
    badgeColor = color;
    libraryStatus = parsedUserData['libraryStatus'];
    fansList.addAll(parsedUserData['fans']);
    blockList.addAll(parsedUserData['blockedBy']);
  }

  String userName;
  String userEmail;
  String userUid;
  String userPhoto;
  String userSince;
  String location;
  String gender;
  String age;
  String workingIn;
  String userStory;
  int booksCount;
  int fansCount;
  int views;
  String status;
  int badgeColor;
  bool libraryStatus = false;
  var fansList = [];
  var blockList = [];
}
