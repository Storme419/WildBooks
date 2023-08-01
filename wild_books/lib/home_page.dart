import 'package:flutter/material.dart';
import 'package:wild_books/book.dart';
import 'package:wild_books/book_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 45,
        ),
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 25),
          decoration: BoxDecoration(
              color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Insert your code here',
                style: TextStyle(color: Colors.grey),
              ),
              Icon(
                Icons.send,
                color: Colors.grey,
              )
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0),
          child: Text(
              'Introducing Wild Books, a web-based application that fosters a reading community and promotes recycling in the most novel way possible. Read more here... ',
              style: TextStyle(fontSize: 20)),
        ),
        const SizedBox(
          height: 45,
        ),
        Expanded(
            child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  Book book = Book(
                      title: 'Crime and Punishment',
                      author: 'Fyodor Dostoyevsky',
                      bookCover: 'lib/images/book2.png');
                  return BookTile(book: book);
                }))
      ],
    );
  }
}
