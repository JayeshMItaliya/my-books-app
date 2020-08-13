import 'package:byebye_flutter_app/firebase_repository/firebase_repository.dart';
import 'package:rxdart/rxdart.dart';

class UserInfoBloc {
  final _firebaseRepository = FirebaseRepository();

  BehaviorSubject<dynamic> userInfo = BehaviorSubject<dynamic>();
  BehaviorSubject<dynamic> userGenre = BehaviorSubject<dynamic>();

  Stream<dynamic> get userInfoStream => userInfo.stream;

  Stream<dynamic> get userGenreStream => userGenre.stream;

  dynamic getUserLibraryInfo(String userId) async {
    final dynamic aboutUserInfo =
        await _firebaseRepository.onGetUserLibraryInfo(userId);
    userInfo.sink.add(aboutUserInfo.userInfo);
    userGenre.sink.add(aboutUserInfo.userGenre);
  }
}

UserInfoBloc userInfoBloc = UserInfoBloc();
