import 'package:byebye_flutter_app/model/user_genre.dart';

class UserGenreHelper {
  UserGenreHelper(
      {dynamic parsedGenreResponse, dynamic parsedLibraryResponse}) {
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
        userGenreList.add(UserGenre(
            parsedResponse: parsedGenreResponse[i].data,
            count: count.toString()));
      }

      userGenreList.sort((a, b) =>
          a.genreName.toLowerCase().compareTo(b.genreName.toLowerCase()));
      final dynamic allCategory = {
        'genreName': 'All',
      };
      userGenreList.insert(0,
          UserGenre(parsedResponse: allCategory, count: allCount.toString()));
    }
  }

  var userGenreList = [];
}
