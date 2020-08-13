class Book {
  Book({dynamic responseData}) {
    bookId = responseData.documentID;
    bookGenre = responseData.data['bookGenre'];
    bookName = responseData.data['bookName'];
    bookPhoto = responseData.data['bookPhoto'];
    bookPrice = responseData.data['bookPrice'];
    bookPurchaseDate = responseData.data['bookPurchaseDate'].toDate();
    bookVolumes = responseData.data['bookVolumes'];
    createdType = responseData.data['createdType'];
    descriptionOfBook = responseData.data['descriptionOfBook'];
    sellerLink = responseData.data['sellerLink'];
    regretOfBook = responseData.data['regretOfBook'];
    isFavourite = responseData.data['favourite'];
    bookRead = responseData.data['bookRead'];
  }

  String bookGenre;
  String bookName;
  String bookPhoto;
  String bookPrice;
  DateTime bookPurchaseDate;
  String bookVolumes;
  String createdType;
  String descriptionOfBook;
  String sellerLink;
  String bookId;
  String regretOfBook;
  bool isFavourite = false;
  int bookRead = 0;

}
