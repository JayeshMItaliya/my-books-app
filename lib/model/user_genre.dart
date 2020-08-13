class UserGenre {
  UserGenre({dynamic parsedResponse, dynamic count}){
    genreName = parsedResponse['genreName'];
    booksCount = count;
}
  String genreName;
  String booksCount;
}