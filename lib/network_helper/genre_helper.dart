import 'package:byebye_flutter_app/model/genre.dart';

class GenreHelper {
  GenreHelper({dynamic parsedGenreResponse, dynamic parsedLibraryResponse}) {
    int count = 0;
    int allCount = 0;
    if (parsedGenreResponse.isNotEmpty) {
      for (int i = 0; i < parsedGenreResponse.length; i++) {
        count = 0;
        for (int j = 0; j < parsedLibraryResponse.length; j++) {
          if (parsedGenreResponse[i].data['genreName'] ==
              parsedLibraryResponse[j].data['bookGenre']) {
            count += int.parse(parsedLibraryResponse[j].data['bookVolumes']);
            allCount += int.parse(parsedLibraryResponse[j].data['bookVolumes']);
          }
        }
        genreList.add(Genre(
            parsedResponse: parsedGenreResponse[i].data,
            documentId: parsedGenreResponse[i].documentID,
            count: count.toString()));
      }
      final dynamic allCategory = {
        'genreName': 'All',
      };
      genreList.insert(
          0,
          Genre(
              parsedResponse: allCategory,
              documentId: '1',
              count: allCount.toString()));
    }
  }

  var genreList = [];
}
