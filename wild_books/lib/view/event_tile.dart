import 'package:flutter/material.dart';
import 'package:wild_books/classes/SingleBookData.dart';
import 'package:wild_books/classes/single_book.dart';
import 'package:wild_books/classes/single_book_event.dart';
import 'package:wild_books/classes/single_book_event_comment.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../utils/db.dart';

class EventTile extends StatefulWidget {
  // SingleBook singleBook;
  // SingleBookEvents singleBookEvent;
  // SingleBookEventComment singleBookEventComment;

  SingleBookData singleBook2;
  SingleBookEvent singleBookEvent;
  SingleBookComment singleBookComment;

  EventTile({
    super.key,
    required this.singleBook2,
    required this.singleBookEvent,
    required this.singleBookComment,
  });

  @override
  State<EventTile> createState() => _EventTileState();
}

class _EventTileState extends State<EventTile> {
  bool hideTextField = false;

  final user = supabase.auth.currentUser;

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onInverseSurface,
                borderRadius: BorderRadius.circular(8),
              ),
              margin: EdgeInsets.only(top: 5, left: 25, right: 25, bottom: 10),
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
                          '${widget.singleBookEvent.event} ${widget.singleBookEvent.username}',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                        Text(
                          timeago.format(
                              DateTime.parse(widget.singleBookEvent.timestamp)),
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.singleBookEvent.userNote,
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          widget.singleBookComment.username,
                          style: TextStyle(
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.singleBookComment.commentsBody,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      child: Text('blah'),
    );
  }
}
