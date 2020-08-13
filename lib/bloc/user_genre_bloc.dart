import 'package:byebye_flutter_app/firebase_repository/firebase_repository.dart';
import 'package:rxdart/rxdart.dart';

class UserGenreBloc {
  final _firebaseRepository = FirebaseRepository();

  BehaviorSubject<dynamic> userGenre = BehaviorSubject<dynamic>();

  Stream<dynamic> get userGenreStream => userGenre.stream;

  dynamic userGenreList(userUid) async {
    final dynamic userGenreData =
        await _firebaseRepository.onGetUserGenre(userUid);
    userGenre.sink.add(userGenreData.userGenreList);
  }

  Future<dynamic> blockUser(userUid) async {
    final dynamic response = await _firebaseRepository.onBlockUser(userUid);
    return response;
  }

  dynamic dispose() {
    userGenre.close();
  }
}

UserGenreBloc userGenreBloc = UserGenreBloc();
