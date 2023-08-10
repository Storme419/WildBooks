import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:wild_books/utils/db.dart';
import 'package:wild_books/view/add_event.dart';
import 'package:wild_books/view/map_page_single_book.dart';
import 'package:wild_books/classes/single_book.dart';
import 'package:wild_books/classes/single_book_event.dart';
import 'package:wild_books/classes/single_book_event_comment.dart';
import 'package:wild_books/view/event_tile.dart';
import 'package:wild_books/view/story_page.dart';
import 'package:wild_books/utils/api.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:wild_books/classes/SingleBookData.dart';

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
                  child: Column(children: [
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
                      child: Text(
                        bookData.description,
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
                      height: 1000,
                      child: ListView.builder(
                        itemCount: bookData.events.length,
                        itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.brown[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      top: 5, left: 25, right: 25, bottom: 10),
                                  padding: EdgeInsets.all(25),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 30),
                                        child: Container(
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
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Found or Released: ${bookData.events[0].event} by ${bookData.events[0].username}',
                                              style: TextStyle(
                                                  color: Colors.grey[500]),
                                            ),
                                            Text(
                                              timeago.format(DateTime.parse(
                                                  bookData.events[0].timestamp)),
                                              style: TextStyle(
                                                  color: Colors.grey[500]),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              bookData.events[0].userNote,
                                              textAlign: TextAlign.left,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                    
                                //comments for event
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.brown[50],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  margin: EdgeInsets.only(
                                      top: 5, left: 25, right: 25, bottom: 10),
                                  padding: EdgeInsets.all(25),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: Text(
                                          'Comments',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(bottom: 70),
                                            child: Container(
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
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  bookData.events[0].comments[0]
                                                      .username,
                                                  style: TextStyle(
                                                    color: Colors.grey[500],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  bookData.events[0].comments[0]
                                                      .commentsBody,
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                TextField(
                                                    style: const TextStyle(
                                                        fontSize: 15),
                                                    onChanged: (text) {
                                                      print(text);
                                                    },
                                                    decoration: InputDecoration(
                                                      suffixIcon: IconButton(
                                                        onPressed: () {},
                                                        icon: Icon(Icons.send),
                                                      ),
                                                      hoverColor:
                                                          Colors.blue[900],
                                                      hintText: 'Post a comment',
                                                      border: const OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      15.0))),
                                                    )),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    )
                  ]),
                ),
              ),
            ),
          );
        });
  }
}



// ListView.builder(itemBuilder: (context, index) {
                      //   SingleBookData singleBook2 = SingleBookData(
                      //       bookId: bookData.bookId,
                      //       code: bookData.code,
                      //       isbn: bookData.isbn,
                      //       title: bookData.title,
                      //       author: bookData.author,
                      //       imgUrl: bookData.imgUrl,
                      //       timestamp: bookData.timestamp,
                      //       isFound: bookData.isFound,
                      //       lat: bookData.lat,
                      //       lng: bookData.lng,
                      //       genreId: bookData.genreId,
                      //       languageId: bookData.languageId,
                      //       storyId: bookData.storyId,
                      //       events: bookData.events[index].event,
                      //       description: bookData.description);
                      //   SingleBookEvents singleBookEvent = SingleBookEvents(
                      //     event: singleBook.events[index].event,
                      //     timestamp: singleBook.events[index].timestamp,
                      //     location: singleBook.events[index].location,
                      //     name: singleBook.events[index].name,
                      //     note: singleBook.events[index].note,
                      //     comments: singleBook.events[index].comments,
                      //   );
                      //   SingleBookEventComment singleBookEventComment =
                      //       SingleBookEventComment(
                      //           userName:
                      //               singleBookEvent.comments[index].userName,
                      //           commentBody: singleBookEvent
                      //               .comments[index].commentBody);
                      // })
                      // Container(
                      //   child: Column(
                      //     children: [
                      //       Text(bookData.bookId)
                      //     ]),
                      // ),

                      //comments and event container
                      // Container(
                      //   height: 600,

                      //   child: FutureBuilder(

                      //       future: getSingleBook('ZM0DV'),
                      //       //need to make code getter to make it dynamic
                      //       builder: (context, snapshot) {
                      //         if (!snapshot.hasData) {
                      //           return const Center(
                      //               child: CircularProgressIndicator());
                      //         }
                      //         final singleBookData = snapshot.data!;

                      //         return ListView.builder(
                      //             itemCount: 3,
                      //             itemBuilder: (context, index) {
                      //               SingleBook singleBook = SingleBook(
                      //                 title: singleBookData.title,
                      //                 author: singleBookData.author,
                      //                 imageUrl: singleBookData.imageUrl,
                      //                 events: singleBookData.events,
                      //               );
                      //               SingleBookEvents singleBookEvent =
                      //                   SingleBookEvents(
                      //                 event: singleBook.events[index].event,
                      //                 timestamp:
                      //                     singleBook.events[index].timestamp,
                      //                 location:
                      //                     singleBook.events[index].location,
                      //                 name: singleBook.events[index].name,
                      //                 note: singleBook.events[index].note,
                      //                 comments:
                      //                     singleBook.events[index].comments,
                      //               );
                      //               SingleBookEventComment
                      //                   singleBookEventComment =
                      //                   SingleBookEventComment(
                      //                       userName: singleBookEvent
                      //                           .comments[index].userName,
                      //                       commentBody: singleBookEvent
                      //                           .comments[index].commentBody);

                      //               return EventTile(
                      //                 singleBook: singleBook,
                      //                 singleBookEvent: singleBookEvent,
                      //                 singleBookEventComment:
                      //                     singleBookEventComment,
                      //               );
                      //             });
                      //       }),
                      // ),