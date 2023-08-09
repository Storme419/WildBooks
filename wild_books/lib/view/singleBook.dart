import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:wild_books/utils/api.dart';
import 'package:wild_books/utils/db.dart';
import 'package:wild_books/view/add_event.dart';
import 'package:wild_books/view/map_page_single_book.dart';
import 'package:wild_books/classes/single_book.dart';
import 'package:wild_books/classes/single_book_event.dart';
import 'package:wild_books/classes/single_book_event_comment.dart';
import 'package:wild_books/view/event_tile.dart';
import 'package:wild_books/view/story_page.dart';
import 'package:expandable_text/expandable_text.dart';

class SingleBookPage extends StatefulWidget {
  final int bookId;

  const SingleBookPage({super.key, required this.bookId});

  @override
  State<SingleBookPage> createState() => _SingleBookPageState();
}

class _SingleBookPageState extends State<SingleBookPage> {
  // TODO hide button automatically if user not logged in
  bool hideButton = false;
  final user = supabase.auth.currentUser;

  initState() {
    user == null ? hideButton = true : null;
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
        future: getSingleBook2(widget.bookId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final bookData = snapshot.data!;

          return Scaffold(
            appBar: AppBar(
              shape: const ContinuousRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(45),
                      bottomLeft: Radius.circular(45))),
              title: Text(bookData.title),
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back),
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
                        child: Image.network(bookData.imgUrl, fit: BoxFit.fill),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '${bookData.title}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      Text(
                        'Author: ${bookData.author}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      hideButton
                          ? Container()
                          : ElevatedButton(
                              onPressed: () async {
                                final bool isEventPosted = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddEvent(
                                            title: bookData.isFound
                                                ? 'Release Book'
                                                : 'Find Book',
                                            event: bookData.isFound
                                                ? 'released'
                                                : 'found',
                                            bookId: bookData.bookId,
                                            userId:
                                                1, // TODO - can't pass this ----> supabase.auth.currentUser.toString(),
                                            // old userId is 'int', data type on profiles table is 'UUID'
                                          )),
                                );

                                if (isEventPosted) {
                                  setState(() {
                                    hideButton = true;
                                  });
                                }
                              },
                              child: Text(bookData.isFound
                                  ? 'Release this book'
                                  : 'I found this book'),
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MapSingleBook(
                                    bookId: bookData.bookId,
                                    title: bookData.title)),
                          );
                        },
                        child: const Text('View journey'),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StoryPage(
                                    bookId: bookData.bookId,
                                    title: bookData.title,
                                    bookCover: bookData.imgUrl)),
                          );
                        },
                        child: const Text('View story'),
                      ),
                      const SizedBox(height: 20),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ExpandableText(
                          bookData.description,
                          expandText: 'Show more',
                          collapseText: 'Show less',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(
                        height: 48,
                      ),
                      
                      
                      //comments and event container
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
                                    SingleBookEvents singleBookEvent =
                                        SingleBookEvents(
                                      event: singleBook.events[index].event,
                                      timestamp:
                                          singleBook.events[index].timestamp,
                                      location:
                                          singleBook.events[index].location,
                                      name: singleBook.events[index].name,
                                      note: singleBook.events[index].note,
                                      comments:
                                          singleBook.events[index].comments,
                                    );
                                    SingleBookEventComment
                                        singleBookEventComment =
                                        SingleBookEventComment(
                                            userName: singleBookEvent
                                                .comments[index].userName,
                                            commentBody: singleBookEvent
                                                .comments[index].commentBody);

                                    return EventTile(
                                      singleBook: singleBook,
                                      singleBookEvent: singleBookEvent,
                                      singleBookEventComment:
                                          singleBookEventComment,
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
        });
  }
}
