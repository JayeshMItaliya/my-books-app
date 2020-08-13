class CreateBookHelper {
  CreateBookHelper(
      {this.bookGenre,
      this.bookName,
      this.bookPrice,
      this.bookPurchaseDate,
      this.bookVolumes,
      this.descriptionOfBook,
      this.sellerLink,
      this.bookPhoto});

  String bookName;
  String bookGenre;
  String bookPrice;
  String bookVolumes;
  DateTime bookPurchaseDate;
  dynamic bookPhoto;
  String sellerLink;
  String descriptionOfBook;
}
