import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:wild_books/model/book.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:wild_books/view/singleBook.dart';

class BookTile extends StatefulWidget {
  final Book book;

  BookTile({super.key, required this.book});

  @override
  State<BookTile> createState() => _BookTileState();
}

class _BookTileState extends State<BookTile> {
  @override
  void initState() {
    getLocation();

    // Make sure to call super.initState();
    super.initState();
  }

  String? city = '';

  Future<void> getLocation() async {
    try {
      List<Placemark> placemark = await placemarkFromCoordinates(
          widget.book.latitude, widget.book.longitude);

      print(placemark);

      setState(() {
        city = placemark[0].locality;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
      child: Container(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SingleBook(
                        book: Book(
                            title: widget.book.title,
                            author: widget.book.author,
                            bookCover: widget.book.bookCover,
                            timestamp: widget.book.timestamp,
                            latitude: widget.book.latitude,
                            longitude: widget.book.longitude))));
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              //side: BorderSide(color: Colors.grey)
            ),
            elevation: 5,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.15,
                      maxHeight: MediaQuery.of(context).size.width * 0.25,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.network(widget.book.bookCover,
                          fit: BoxFit.fill),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30, 10, 0, 0),
                        child: Text(
                          'Title: ${widget.book.title}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30, 10, 0, 0),
                        child: Text(
                          'Author: ${widget.book.author}',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30, 10, 0, 0),
                        child: Text(
                          'Released in ${city} ${timeago.format(widget.book.timestamp)}',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
