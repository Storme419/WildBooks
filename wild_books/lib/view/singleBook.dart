import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:wild_books/utils/api.dart';
import 'package:wild_books/utils/db.dart';
import 'package:wild_books/view/add_event.dart';
import 'package:wild_books/view/map_page_single_book.dart';
import 'package:wild_books/classes/SingleBookData.dart';
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
                              child: Text(
                                  bookData.isFound
                                      ? 'Release this book'
                                      : 'I found this book',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  )),
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
                        child: const Text('View journey',
                            style: TextStyle(
                              color: Colors.grey,
                            )),
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
                                      bookCover: bookData.imgUrl,
                                      description: bookData.description,
                                    )),
                          );
                        },
                        child: const Text('View story',
                            style: TextStyle(
                              color: Colors.grey,
                            )),
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
                      // final String bookCommentsAvailability = bookData.events[index].comments;

                      Container(
                        height: 2000,
                        child: ListView.builder(
                            itemCount: bookData.events.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onInverseSurface,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      margin: EdgeInsets.only(
                                          top: 5,
                                          left: 25,
                                          right: 25,
                                          bottom: 10),
                                      padding: EdgeInsets.all(25),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(bottom: 200, ),
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
                                                  '${bookData.events[index].event} by ${bookData.events[index].username}',
                                                  style: TextStyle(
                                                      color: Colors.grey[500]),
                                                ),
                                                Text(
                                                  timeago.format(DateTime.parse(
                                                      bookData.events[index]
                                                          .timestamp)),
                                                  style: TextStyle(
                                                      color: Colors.grey[500]),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  bookData
                                                      .events[index].userNote,
                                                  textAlign: TextAlign.left,
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),

                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 20),
                                                  child: Text(
                                                    'Comments',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),

                                                if (bookData.events[index]
                                                        .comments.length ==
                                                    0) ...[
                                                  Text('No Comments')
                                                ] else ...[
                                                  Text(
                                                    bookData.events[index]
                                                        .comments[0].username,
                                                    style: TextStyle(
                                                      color: Colors.grey[500],
                                                    ),
                                                  ),
                                                ],

                                                const SizedBox(
                                                  height: 5,
                                                ),

                                                if (bookData.events[index]
                                                        .comments.length ==
                                                    0) ...[
                                                  Text('No Comments'),
                                                ] else ...[
                                                  Text(
                                                    bookData
                                                        .events[index]
                                                        .comments[0]
                                                        .commentsBody,
                                                  ),
                                                ],
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
                                                      hintText:
                                                          'Post a comment',
                                                      border: const OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      15.0))),
                                                    )),
                                                // Text(
                                                //   bookData
                                                //       .events[index]
                                                //       .comments[index]
                                                //       .commentsBody,
                                                // ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                              //end here
                            }),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
