import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:wild_books/model/book.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:wild_books/utils/db.dart';
import 'package:wild_books/classes/single_book_event.dart';
import 'package:wild_books/view/event_tile.dart';

// https://didtheylikeit.com/wp-content/uploads/2022/07/TheKiteRunner300x400-2.png

class SingleBookPage extends StatelessWidget {
  Book book;
  SingleBookPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Book'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: Image.network(book.bookCover, fit: BoxFit.fill),
                ),
                const SizedBox(height: 48),
                Text(
                  'Title: ${book.title}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                Text(
                  'Author: ${book.author}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Text(
                    'This is a fake description box to lure you in to our amazing app. Bit more text.',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(
                  height: 48,
                ),

                //comments container
                Container(
                  decoration: BoxDecoration(
                    color: Colors.brown[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin:
                      EdgeInsets.only(top: 5, left: 25, right: 25, bottom: 10),
                  padding: EdgeInsets.all(25),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[400],
                        ),
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(
                          right: 15,
                        ),
                        child: const Icon(Icons.person),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Released by HardcodedUsername2 in Paris',
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                            Text(
                              timeago.format(book.timestamp),
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Absolutely loved this book and could not contain my love for this book so I've left it on top of the statue at the tea gardens",
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextField(
                              style: TextStyle(fontSize: 15),
                              onChanged: (text) {
                                print(text);
                              },
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.send),
                                ),
                                hintText: 'Post a comment',
                                border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15.0))),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                Container(
                  height: 1000,
                  color: Colors.blueGrey[500],
                  child: FutureBuilder(
                      future: getSingleBook('E59O7'),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        final singleBookData = snapshot.data!;

                        // "${today.year.toString()}-${today.month.toString().padLeft(2,'0')}-${today.day.toString().padLeft(2,'0')}"
                        // final today = DateTime.parse(singleBookData[1]['timestamp']);
                        // final dateSlug =
                        //     "${today.year.toString()}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
                        // debugPrint(dateSlug.runtimeType.toString());

                        return ListView.builder(
                            itemCount: singleBookData.length,
                            itemBuilder: (context, index) {
                              SingleBookEvent singleBook = SingleBookEvent(
                                name: singleBookData[index]['name'],
                                timestamp: DateTime.parse(
                                    singleBookData[index]['timestamp']),
                                event: singleBookData[index]['event'],
                                note: singleBookData[index]['note'],
                                comments: singleBookData[index]['comments']
                                    [index]['comments_body'],
                                location: singleBookData[index]['location'],
                              );
                              return EventTile(singleBook: singleBook);
                            });
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
