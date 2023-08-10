import 'package:flutter/material.dart';
import 'package:wild_books/model/book.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:wild_books/model/location.dart';
import 'package:wild_books/view/singleBook.dart';

class BookTile extends StatelessWidget {
  final Book book;
  final userLocation = UserLocation();

  BookTile({super.key, required this.book});

  String? city;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 20),
      child: Container(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SingleBookPage(bookId: book.bookId)));
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              //side: BorderSide(color: Colors.grey)
            ),
            elevation: 3,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.5,
                      maxHeight: MediaQuery.of(context).size.width * 0.25,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.network(book.bookCover, fit: BoxFit.fill),
                    ),
                  ),
                ),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(30, 5, 0, 5),
                          child: Text(
                            '${book.getEvent()}!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(30, 5, 0, 5),
                          child: Text(
                            '${book.title},\n${book.author}',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(30, 5, 0, 5),
                          child: FutureBuilder(
                            future: userLocation.getLocation(
                                book.latitude, book.longitude),
                            builder: (context, snapshot) {
                              debugPrint(snapshot.data.toString());

                              return Text(
                                  '${snapshot.data.toString()}, ${timeago.format(book.timestamp)}',
                                  style: TextStyle(
                                    fontSize: 13,
                                  ));
                            },
                          ),
                        ),
                      ),
                    ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
