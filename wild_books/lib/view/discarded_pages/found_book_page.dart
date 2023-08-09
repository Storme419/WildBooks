import 'package:flutter/material.dart';

class FoundBook extends StatefulWidget {
  const FoundBook({super.key});

  @override
  State<FoundBook> createState() => _FoundBookState();
}

class _FoundBookState extends State<FoundBook> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(45),
                bottomLeft: Radius.circular(45))),
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
