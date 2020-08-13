import 'package:byebye_flutter_app/firebase_repository/firebase_repository.dart';
import 'package:rxdart/rxdart.dart';

class AddGenreBloc {
  final _firebaseRepository = FirebaseRepository();

  BehaviorSubject<String> genreName = BehaviorSubject<String>();

  Stream<String> get genreNameStream => genreName.stream;

  Future<dynamic> addNewGenre(String nameOfGenre) async {
    final dynamic response = await _firebaseRepository.addNewGenre(nameOfGenre);
    return response;
  }
}

AddGenreBloc addGenreBloc = AddGenreBloc();
