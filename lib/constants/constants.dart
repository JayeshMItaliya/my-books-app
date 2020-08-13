class Constants {
  // TODO(Test): Replace this with your firebase project URL
  static const String firebaseProjectURL =
      'https://byebye-48e57.firebaseio.com';

  static const List<String> monthList = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
}

enum BookCreateType { createBook, editBook }
enum BookEditType { fromBookList, fromBookDetail }
enum BookViewType { owner, bookLover }
enum UserViewType { owner, connection }
enum NavigateFrom { stats, library, bookLover, chat }
