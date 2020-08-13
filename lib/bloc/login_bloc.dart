import 'package:rxdart/rxdart.dart';

class LoginBloc {
  BehaviorSubject<String> loginValue = BehaviorSubject<String>();

  Stream<String> get loginStream => loginValue.stream;
}

LoginBloc loginBloc = LoginBloc();
