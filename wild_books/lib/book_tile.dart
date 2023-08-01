import 'package:flutter/material.dart';
import 'package:wild_books/book.dart';

class BookTile extends StatelessWidget {
  Book book;
  BookTile({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListTile(
      leading: SizedBox(
        width: 100,
        height: 500,
        child: Image.asset(book.bookCover, fit: BoxFit.fill),
      ),
      title: Text('Title: ${book.title}',
          style: TextStyle(color: Colors.grey[600], fontSize: 20)),
      subtitle: Text(
        'Author: ${book.author}',
        style: TextStyle(color: Colors.grey[600], fontSize: 15),
      ),
      // margin: EdgeInsets.only(left: 25),
      // width: 200,
      // decoration: BoxDecoration(
      //     color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
      // child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      //   Image.asset(book.bookCover),
      //   Row(
      //     crossAxisAlignment: CrossAxisAlignment.end,
      //     children: [
      //       Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
      //         Text('Title: ${book.title}',
      //             style: TextStyle(color: Colors.grey[600], fontSize: 20)),
      //         Text('Author: ${book.author}',
      //             style: TextStyle(color: Colors.grey[600], fontSize: 15))
      //       ])
      //     ],
      //   )
      // ]),
    ));
  }
}
