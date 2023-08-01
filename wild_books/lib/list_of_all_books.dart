import 'package:flutter/material.dart';

class ListOfBooks extends StatefulWidget {
  const ListOfBooks({super.key});

  @override
  State<ListOfBooks> createState() => _ListOfBooksState();
}

class _ListOfBooksState extends State<ListOfBooks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of books'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
    );
  }
}
