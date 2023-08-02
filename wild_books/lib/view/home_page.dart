import 'package:flutter/material.dart';
import 'package:wild_books/model/book.dart';
import 'package:wild_books/view/book_tile.dart';
import 'package:wild_books/utils/db.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: Column(children: [
                TextField(
                    onChanged: (text) {
                      print(text);
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.send),
                      ),
                      hintText: 'Please enter your code here',
                      border: const OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
                    )),
              ]),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0),
              child: Text(
                  'Introducing Wild Books, a web-based application that fosters a reading community and promotes recycling in the most novel way possible. Read more here... ',
                  style: TextStyle(fontSize: 20)),
            ),
            Expanded(
              child: FutureBuilder(
                  future: getBooks(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final books = snapshot.data!;
                    debugPrint(books.toString());
                    return ListView.builder(
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          Book book = Book(
                              title: books[index]['title'],
                              author: books[index]['author'],
                              bookCover: books[index]['image_url'],
                              timestamp: DateTime.parse(books[index]['timestamp']));
                          return BookTile(book: book);
                        });
                  }),
            )
          ],
        ),
      ),
    );
  }
}
