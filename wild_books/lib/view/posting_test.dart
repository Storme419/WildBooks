import 'package:flutter/material.dart';
import 'package:wild_books/utils/db.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: ElevatedButton(
            child: Text('Click me'),
            onPressed: () => addStoryComment(
                1, 2, '9780439708180', 'testing story comment')));
  }
}


// Container(
//         child: ElevatedButton(
//             child: Text('Click me'),
//             onPressed: () => addStoryComment(
//                 1, 2, '9780439708180', 'added id manually')));