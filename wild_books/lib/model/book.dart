import 'package:geocoding/geocoding.dart';

class Book {
  final String title;
  final String author;
  final String bookCover;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
 

  Book({
    required this.title,
    required this.author,
    required this.bookCover,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
  });


}
