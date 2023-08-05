import 'package:flutter/material.dart';
import 'package:wild_books/model/book.dart';
import 'package:wild_books/view/book_tile.dart';
import 'package:wild_books/utils/db.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(50, 15, 50, 5),
              width: MediaQuery.of(context).size.width,
              height: 110,
              child: Column(children: [
                TextField(
                    onChanged: (text) {
                      print(text);
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/add-book');
                        },
                        icon: const Icon(Icons.send),
                      ),
                      label: Text(
                        'Found a book?',
                      ),
                      hintText: 'Please enter your code here',
                      border: const OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
                    )),
                Wrap(children: [
                  Text('Want to release a book instead? '),
                  InkWell(
                    onTap: () => Navigator.of(context).pushNamed('/get-code'),
                    child: Text('Generate a code here'),
                  ),
                ])
              ]),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(30, 20, 20, 40),
              child: const Text(
                  'Introducing Wild Books, a web-based application that fosters a reading community and promotes recycling in the most novel way possible.',
                  style: TextStyle(fontSize: 20)),
            ),
            Padding(
              padding: EdgeInsets.all(2),
              child: SegmentedButton<String>(
                segments: const [
                  ButtonSegment<String>(
                      value: 'all',
                      label: Text('All books'),
                      icon: Icon(Icons.done_sharp)),
                  ButtonSegment<String>(
                      value: 'found',
                      label: Text('found books'),
                      icon: Icon(Icons.pin_drop)),
                  ButtonSegment<String>(
                      value: 'released',
                      label: Text('Released books'),
                      icon: Icon(Icons.my_library_books)),
                  ButtonSegment<String>(
                      value: 'liked',
                      label: Text('Popular books'),
                      icon: Icon(Icons.favorite)),
                ],
                selected: <String>{'all'},
                onSelectionChanged: (Set<String> newSelection) {},
              ),
            ),
            Expanded(
              child: FutureBuilder(
                  future: getBooks(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final books = snapshot.data!;
                    return ListView.builder(
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          Book book = Book(
                              title: books[index]['title'],
                              author: books[index]['author'],
                              bookCover: books[index]['image_url'],
                              timestamp:
                                  DateTime.parse(books[index]['timestamp']));
                          return BookTile(book: book);
                        });
                  }),
            )
          ],
        ),
      ),
    );
  }
}
