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
            onPressed: () {
              try {
                addEvent(
                    2, 2, 'released', 41.40338, 2.17403, 'left on the bench');
              } catch (e) {
                debugPrint(e.toString());
              }
            }));
  }
}
