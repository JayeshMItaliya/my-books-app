import 'package:byebye_flutter_app/firebase_repository/firebase_repository.dart';
import 'package:rxdart/rxdart.dart';

class GenreBloc {
  final _firebaseRepository = FirebaseRepository();

  BehaviorSubject<dynamic> aboutGenres = BehaviorSubject<dynamic>();
  BehaviorSubject<dynamic> genres = BehaviorSubject<dynamic>();
  BehaviorSubject<dynamic> genreOption = BehaviorSubject<dynamic>();

  Stream<dynamic> get aboutGenresStream => aboutGenres.stream;
  Stream<dynamic> get genreStream => genres.stream;

  Stream<dynamic> get genreOptionStream => genreOption.stream;

  dynamic aboutUserGenres = [];
  dynamic aboutGenre() async {
    aboutUserGenres = await _firebaseRepository.onGetAboutGenres();
    aboutGenres.sink.add(aboutUserGenres);
  }

  dynamic genreData = [];
  dynamic tempList = [];

  dynamic genreList(userUid) async {
    genreData = await _firebaseRepository.onGetGenre(userUid);
    tempList = genreData;
    genres.sink.add(genreData.genreList);
  }

  dynamic genreOptions(String option) {
    genreOption.sink.add(option);
    return option;
  }

  Future<dynamic> editGenreName(
      String genreName, String oldGenreName, String genreID) async {
    final dynamic response =
        await _firebaseRepository.onEditGenre(genreName, oldGenreName, genreID);
    return response;
  }

  Future<dynamic> deleteGenre(String genreName, String genreId) async {
    final dynamic response =
        await _firebaseRepository.onDeleteGenre(genreName, genreId);
    return response;
  }

  dynamic searchList = [];

  dynamic searchGenre(String searchText) {
    searchList = [];
    if (searchText.isEmpty) {
      genres.sink.add(tempList.genreList);
    } else {
      for (int i = 0; i < genreData.genreList.length; i++) {
        if (genreData.genreList[i].genreName
            .toLowerCase()
            .contains(searchText.toLowerCase())) {
          searchList.add(genreData.genreList[i]);
        }
      }
      genres.sink.add(searchList);
    }
  }
}

GenreBloc genreBloc = GenreBloc();
