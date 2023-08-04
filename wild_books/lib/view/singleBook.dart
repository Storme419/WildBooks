import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:wild_books/model/book.dart';
// https://didtheylikeit.com/wp-content/uploads/2022/07/TheKiteRunner300x400-2.png

class SingleBook extends StatelessWidget {
  Book book;
  SingleBook({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Book'),
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
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: Image.network(
                      'https://didtheylikeit.com/wp-content/uploads/2022/07/TheKiteRunner300x400-2.png',
                      fit: BoxFit.fill),
                ),
                const SizedBox(height: 48),
                const Text(
                  'Title: Kite Runner',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const Text(
                  'Author: Khaled Hosseini',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                const Text(
                  'This is a fake description box to lure you in to our amazing app. Bit more text.',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
