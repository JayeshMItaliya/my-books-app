import 'package:byebye_flutter_app/firebase_repository/firebase_repository.dart';
import 'package:rxdart/rxdart.dart';

class UserConnectionBloc {
  final _firebaseRepository = FirebaseRepository();

  BehaviorSubject<dynamic> userConnection = BehaviorSubject<dynamic>();

  Stream<dynamic> get userConnectionStream => userConnection.stream;

  dynamic userConnectionList(userUid) async {
    final dynamic userConnectionData =
        await _firebaseRepository.onGetUserConnectionList(userUid);
    userConnection.sink.add(userConnectionData.userConnectionList);
  }

  void dispose() {
    userConnection.close();
  }
}

UserConnectionBloc userConnectionBloc = UserConnectionBloc();
