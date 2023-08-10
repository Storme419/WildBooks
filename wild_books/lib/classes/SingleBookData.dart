import 'package:wild_books/classes/single_book_event_comment.dart';

class SingleBookData {
  final int bookId;
  final String code;
  final int isbn;
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
  List<SingleBookEvent> events;
  final String description;

  //code

  SingleBookData(
    this.bookId,
    this.code,
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
    this.events,
    this.description,
  );
}

class SingleBookEvent {
  final int eventId;
  final int bookId;
  final String event;
  final String timestamp;
  final double lat;
  final double lng;
  final int userId;
  final String username;
  final String userNote;
  List<SingleBookComment> comments;

  SingleBookEvent({
    required this.eventId,
    required this.bookId,
    required this.event,
    required this.timestamp,
    required this.lat,
    required this.lng,
    required this.userId,
    required this.username,
    required this.userNote,
    required this.comments,
  });
}

class SingleBookComment {
  final int commentId;
  // final int eventId;
  // final String timestamp;
  // final int userId;
  final String username;
  final String commentsBody;

  SingleBookComment({
    required this.commentId,
    // required this.eventId,
    // required this.timestamp,
    // required this.userId,
    required this.username,
    required this.commentsBody,
  });
}
