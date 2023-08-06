import 'package:flutter/material.dart';
import 'package:wild_books/classes/single_book_event.dart';

class EventTile extends StatelessWidget{
  SingleBookEvent singleBook;
  EventTile({super.key, required this.singleBook});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        height: 400,
        color: Colors.deepPurple[200],
        child: Center(
          child: Text(
            singleBook.note,
            style: TextStyle(fontSize: 40),)),
      ),
    );
  }
}
