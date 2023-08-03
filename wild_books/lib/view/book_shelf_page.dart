import 'package:flutter/material.dart';
import 'package:wild_books/classes/BookshelfData.dart';
import 'package:intl/intl.dart';

class Bookshelf extends StatefulWidget {
  const Bookshelf({super.key});
  //const Bookshelf({super.key, required this.userId});

  //final int userId;

  @override
  State<Bookshelf> createState() => _BookshelfState();
}

class _BookshelfState extends State<Bookshelf> {

  List<BookshelfData> bookshelfData = [
    BookshelfData(bookId: 1, bookImgUrl: 'https://covers.openlibrary.org/b/id/13147279-M.jpg'),
    BookshelfData(bookId: 1, bookImgUrl: 'https://covers.openlibrary.org/b/id/13147279-M.jpg'),
    BookshelfData(bookId: 1, bookImgUrl: 'https://covers.openlibrary.org/b/id/13147279-M.jpg'),
    BookshelfData(bookId: 1, bookImgUrl: 'https://covers.openlibrary.org/b/id/13147279-M.jpg'),
    BookshelfData(bookId: 1, bookImgUrl: 'https://covers.openlibrary.org/b/id/13147279-M.jpg'),
    BookshelfData(bookId: 1, bookImgUrl: 'https://covers.openlibrary.org/b/id/13147279-M.jpg'),
    BookshelfData(bookId: 1, bookImgUrl: 'https://covers.openlibrary.org/b/id/13147279-M.jpg'),
    BookshelfData(bookId: 1, bookImgUrl: 'https://covers.openlibrary.org/b/id/13147279-M.jpg'),
    BookshelfData(bookId: 1, bookImgUrl: 'https://covers.openlibrary.org/b/id/13147279-M.jpg'),
    BookshelfData(bookId: 1, bookImgUrl: 'https://covers.openlibrary.org/b/id/13147279-M.jpg'),
    BookshelfData(bookId: 1, bookImgUrl: 'https://covers.openlibrary.org/b/id/13147279-M.jpg'),
    BookshelfData(bookId: 1, bookImgUrl: 'https://covers.openlibrary.org/b/id/13147279-M.jpg'),
    BookshelfData(bookId: 1, bookImgUrl: 'https://covers.openlibrary.org/b/id/13147279-M.jpg'),
    BookshelfData(bookId: 1, bookImgUrl: 'https://covers.openlibrary.org/b/id/13147279-M.jpg'),
    BookshelfData(bookId: 1, bookImgUrl: 'https://covers.openlibrary.org/b/id/13147279-M.jpg'),
    BookshelfData(bookId: 1, bookImgUrl: 'https://covers.openlibrary.org/b/id/13147279-M.jpg'),
    BookshelfData(bookId: 1, bookImgUrl: 'https://covers.openlibrary.org/b/id/13147279-M.jpg'),
    BookshelfData(bookId: 1, bookImgUrl: 'https://covers.openlibrary.org/b/id/13147279-M.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GridView.count(
          crossAxisCount: 3,
          children: List.generate(bookshelfData.length, (index) {
            return GestureDetector(
              onTap: () {
                debugPrint('navigate to single book ${bookshelfData[index].bookId}');
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Image.network(bookshelfData[index].bookImgUrl),
              ),
            );
          }),
        ),
      ),
    );
  }
}
