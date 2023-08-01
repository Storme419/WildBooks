import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wild_books/book.dart';
import 'package:wild_books/book_tile.dart';
import 'package:wild_books/utils/db.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 15,
      ),
      SingleChildScrollView(
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        onChanged: (text) {
                          print(text);
                        },
                        decoration: const InputDecoration(
                            filled: true,
                            hintText: 'Please enter your code here',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)))),
                      ),
                      // Container(
                      //   padding: const EdgeInsets.all(12),
                      //   margin: const EdgeInsets.symmetric(horizontal: 25),
                      //   decoration: BoxDecoration(
                      //       color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
                      //   child: const Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Text(
                      //         'Insert your code here',
                      //         style: TextStyle(color: Colors.grey),
                      //       ),
                      //       Icon(
                      //         Icons.send,
                      //         color: Colors.grey,
                      //       )
                      //     ],
                      //   ),
                      // ),
                      const Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 50.0, horizontal: 20.0),
                        child: Text(
                            'Introducing Wild Books, a web-based application that fosters a reading community and promotes recycling in the most novel way possible. Read more here... ',
                            style: TextStyle(fontSize: 20)),
                      ),
                      Expanded(
                          child: FutureBuilder(
                              future: getBooks(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                final books = snapshot.data!;
                                debugPrint(books.toString());
                                return ListView.builder(
                                    itemCount: 10,
                                    itemBuilder: (context, index) {
                                      Book book = Book(
                                          title: books[index]['title'],
                                          author: books[index]['author'],
                                          bookCover: books[index]['image_url']);
                                      return BookTile(book: book);
                                    });
                              }))
                    ],
                  ))))
    ]);
  }
}
