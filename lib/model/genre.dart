class Genre {
  Genre({dynamic parsedResponse, dynamic documentId, dynamic count}) {
    genreName = parsedResponse['genreName'];
    genreId = documentId;
    booksCount = count;
  }

  String genreName;
  String booksCount;
  String genreId;
}
