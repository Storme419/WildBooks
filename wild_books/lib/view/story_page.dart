import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:wild_books/classes/BookData.dart';
import 'package:wild_books/utils/db.dart';
import 'package:wild_books/view/add_event.dart';

class StoryPage extends StatefulWidget {
  const StoryPage(
      {super.key,
      required this.bookId,
      required this.title,
      required this.bookCover});

  final int bookId;
  final String title;
  final String bookCover;
  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
    bool hideButton = false;

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

                      const SizedBox(height: 20),

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

                      //comments and event container
                  //     Container(
                  //       height: 600,
                  //       child: FutureBuilder(
                  //           //need to change this to storyId
                  //           future: getStory(1),
                  //           builder: (context, snapshot) {
                  //            
                    ],
                  ),
                ),
              ),
            ),
          );
        });
    ;
  }
}
