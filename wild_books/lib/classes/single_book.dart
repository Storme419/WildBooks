import 'package:wild_books/classes/single_book_event.dart';
class SingleBook {
  final String title;
  final String author;
  final String imageUrl;
  List<SingleBookEvent> events;

  SingleBook(
      {required this.title,
      required this.author,
      required this.imageUrl,
      required this.events});
}