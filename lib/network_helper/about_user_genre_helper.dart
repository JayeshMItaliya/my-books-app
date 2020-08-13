class AboutUserGenreHelper {
  AboutUserGenreHelper({dynamic parsedResponse}) {
    int books = 0;
    int booksValue = 0;
    int booksFavourite = 0;
    int booksRegret = 0;
    if (parsedResponse.isNotEmpty) {
      for (dynamic book in parsedResponse) {
        books += int.parse(book['bookVolumes']);
        booksValue += int.parse(book['bookPrice']);
        if(book['favourite']){
          booksFavourite++;
        }
        if (book['regretOfBook'] != '') {
          booksRegret++;
        }
      }
      aboutGenres.add(books);
      aboutGenres.add(booksValue);
      aboutGenres.add(booksFavourite);
      aboutGenres.add(booksRegret);
    }
  }

  var aboutGenres = [];
}
