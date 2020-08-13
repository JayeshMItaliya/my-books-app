import 'package:byebye_flutter_app/firebase_repository/firebase_repository.dart';

class LibraryStatusBloc {
  final _firebaseRepository = FirebaseRepository();

  dynamic getLibraryStatus() async {
    final dynamic response = await _firebaseRepository.onGetLibraryStatus();
    return response;
  }

  dynamic changeLibraryStatus(bool status) async {
    final dynamic response =
        await _firebaseRepository.onChangeLibraryStatus(status);
    return response;
  }
}

LibraryStatusBloc libraryStatusBloc = LibraryStatusBloc();
