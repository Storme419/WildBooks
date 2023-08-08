import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:wild_books/utils/db.dart';
import 'package:wild_books/view/add_event.dart';

// https://didtheylikeit.com/wp-content/uploads/2022/07/TheKiteRunner300x400-2.png

class SingleBookPage extends StatefulWidget {
  final int bookId;

  const SingleBookPage({super.key, required this.bookId});

  @override
  State<SingleBookPage> createState() => _SingleBookPageState();
}

class _SingleBookPageState extends State<SingleBookPage> {
  // TODO hide button automatically if user not logged in
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
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      Text(
                        'Author: ${bookData.author}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      hideButton
                          ? Container()
                          : ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  hideButton = true;
                                });
                                Navigator.push(
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
                                            userId: 1, // TODO - can't pass this ----> supabase.auth.currentUser.toString(),
                                                        // old userId is 'int', data type on profiles table is 'UUID'
                                          )),
                                );
                              },
                              child: Text(bookData.isFound
                                  ? 'Release this book'
                                  : 'I found this book'),
                            ),
                      ElevatedButton(
                        onPressed: () {
                          debugPrint(supabase.auth.currentUser.toString());
                        },
                        child: const Text('View journey'),
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

                      //comments container
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.brown[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: EdgeInsets.only(
                            top: 5, left: 25, right: 25, bottom: 10),
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
                                    timeago.format(
                                        DateTime.parse(bookData.timestamp)),
                                    //important!!!
                                    //
                                    //
                                    //timestamp above is pulled from the books table and not linked to the events as of yet
                                    //please delete these comments when it has been implemented
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
                                      ))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.brown[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: EdgeInsets.only(
                            top: 5, left: 25, right: 25, bottom: 10),
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
                                    'Released by HardcodedUsername1 in Paris',
                                    style: TextStyle(color: Colors.grey[500]),
                                  ),
                                  Text(
                                    '${timeago.format(DateTime.parse(bookData.timestamp))}',
                                    //important!!!
                                    //
                                    //
                                    //timestamp above is pulled from the books table and not linked to the events as of yet
                                    //please delete these comments when it has been implemented
                                    style: TextStyle(color: Colors.grey[500]),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Wow everyone's right...I also loved it and could not contain my love for this book so I've left it underneath the statue at the tea gardens",
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
                                                Radius.circular(5.0))),
                                      ))
                                ],
                              ),
                            )
                          ],
                        ),
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
