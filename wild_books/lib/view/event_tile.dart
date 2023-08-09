import 'package:flutter/material.dart';
import 'package:wild_books/classes/single_book.dart';
import 'package:wild_books/classes/single_book_event.dart';
import 'package:wild_books/classes/single_book_event_comment.dart';
import 'package:timeago/timeago.dart' as timeago;

class EventTile extends StatelessWidget {
  SingleBook singleBook;
  SingleBookEvents singleBookEvent;
  SingleBookEventComment singleBookEventComment;

  EventTile(
      {super.key,
      required this.singleBook,
      required this.singleBookEvent,
      required this.singleBookEventComment});

  @override
  Widget build(BuildContext context) {
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
              margin: EdgeInsets.only(top: 5, left: 25, right: 25, bottom: 10),
              padding: EdgeInsets.all(25),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Released by ${singleBookEvent.name}',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                        Text(
                          timeago.format(
                              DateTime.parse(singleBookEvent.timestamp)),
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          singleBookEvent.note,
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
              margin: EdgeInsets.only(top: 5, left: 25, right: 25, bottom: 10),
              padding: EdgeInsets.all(25),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
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
                        padding: const EdgeInsets.only(bottom: 70),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              singleBookEventComment.userName,
                              style: TextStyle(
                                color: Colors.grey[500],
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              singleBookEventComment.commentBody,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextField(
                                style: const TextStyle(fontSize: 15),
                                onChanged: (text) {
                                  print(text);
                                },
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.send),
                                  ),
                                  hoverColor: Colors.blue[900],
                                  hintText: 'Post a comment',
                                  border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0))),
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
  }
}
