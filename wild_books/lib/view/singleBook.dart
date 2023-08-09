import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:wild_books/classes/single_book_event.dart';
import 'package:wild_books/classes/single_book_event_comment.dart';
import 'package:wild_books/model/book.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:wild_books/classes/single_book.dart';
import 'package:wild_books/utils/db.dart';
import 'package:wild_books/view/test_event_tile.dart';

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
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                Text(
                  'Author: ${book.author}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
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
                //new container to be created
                

                Container(
                  height: 600,
                  child: FutureBuilder(
                      future: getSingleBook('ZM0DV'),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        final singleBookData = snapshot.data!;
                        //         // final today =
                        //         //     DateTime.parse(singleBookData[1]['timestamp']);
                        //         // final dateSlug =
                        //         //     "${today.year.toString()}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

                        return ListView.builder(
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              SingleBook singleBook = SingleBook(
                                title: singleBookData.title,
                                author: singleBookData.author,
                                imageUrl: singleBookData.imageUrl,
                                events: singleBookData.events,
                              );
                              SingleBookEvent singleBookEvent = SingleBookEvent(
                                event: singleBook.events[index].event,
                                timestamp: singleBook.events[index].timestamp,
                                location: singleBook.events[index].location,
                                name: singleBook.events[index].name,
                                note: singleBook.events[index].note,
                                comments: singleBook.events[index].comments,
                              );
                              SingleBookEventComment singleBookEventComment =
                                  SingleBookEventComment(
                                      userName: singleBookEvent
                                          .comments[index].userName,
                                      commentBody: singleBookEvent
                                          .comments[index].commentBody);
                              
                              return TestEventTile(
                                singleBook: singleBook,
                                singleBookEvent: singleBookEvent,
                                singleBookEventComment: singleBookEventComment,
                              );
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
