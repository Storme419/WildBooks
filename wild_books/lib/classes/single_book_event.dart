import 'package:wild_books/classes/single_book_event_comment.dart';

class SingleBookEvents {
  final String event;
  final String timestamp;
  // final double latitude;
  // final double longitude;
  final String location;
  final String name;
  final String note;
  List<SingleBookEventComment> comments;

  SingleBookEvents(
      {required this.event,
      required this.timestamp,
      // required this.latitude,
      // required this.longitude,
      required this.location,
      required this.name,
      required this.note,
      required this.comments
      });
}

// import 'package:wild_books/classes/single_book_event_comment.dart';
// class SingleBookEvent {
//   final String event;
//   final String timestamp;
//   final double latitude;
//   final double longitude;
//   final String name;
//   final String note;
//   List<SingleBookEventComment> comments;

//   SingleBookEvent(
//       {required this.event,
//       required this.timestamp,
//       required this.latitude,
//       required this.longitude,
//       required this.name,
//       required this.note,
//       required this.comments});
// }