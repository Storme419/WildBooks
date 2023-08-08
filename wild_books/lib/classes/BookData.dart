class BookData {
  final String isbn;
  final String title;
  final String author;
  final String imgUrl;
  final String timestamp;
  final bool isFound;
  final double lat;
  final double lng;
  final int genreId;
  final int languageId;
  final int storyId;

  //code

  BookData(
    this.isbn,
    this.title,
    this.author,
    this.imgUrl,
    this.timestamp,
    this.isFound,
    this.lat,
    this.lng,
    this.genreId,
    this.languageId,
    this.storyId,
  );
}
