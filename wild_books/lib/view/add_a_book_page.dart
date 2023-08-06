import 'package:flutter/material.dart';
import 'dart:math';

class AddBook extends StatefulWidget {
  const AddBook({super.key});

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  int id = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a book'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Column(children: [
        Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: SizedBox(
              child: ElevatedButton(
            child: Text('Generate your book code'),
            onPressed: () {
              setState(() {
                id = Random.secure().nextInt(5170000);
              });
            },
          )),
        ),
        SizedBox(
            child:
                Text('Please write this code on the first page of you book:')),
        SizedBox(
            child: Text(
          id.toString(),
          style: TextStyle(fontWeight: FontWeight.w600),
        )),
      ]),
    );
  }
}
