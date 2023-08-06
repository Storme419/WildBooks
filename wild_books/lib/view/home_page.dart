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
              padding: const EdgeInsets.fromLTRB(30, 20, 20, 0),
              child: Wrap(children: [
                const Text('What\'s Wild Books?',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                InkWell(
                  onTap: () => Navigator.of(context).pushNamed('/about-us'),
                  child: const Text(' Know more about us.',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                )
              ]),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(25, 25, 25, 10),
              width: MediaQuery.of(context).size.width,
              height: 120,
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
            Padding(
              padding: EdgeInsets.all(2),
              child: SegmentedButton<String>(
                segments: const [
                  ButtonSegment<String>(
                    value: 'all',
                    label: Text('All books'),
                    // icon: Icon(Icons.done_sharp)
                  ),
                  ButtonSegment<String>(
                    value: 'found',
                    label: Text('Found'),
                    //   icon: Icon(Icons.pin_drop)
                  ),
                  ButtonSegment<String>(
                    value: 'released',
                    label: Text('Released'),
                    //   icon: Icon(Icons.my_library_books)
                  ),
                  ButtonSegment<String>(
                    value: 'liked',
                    label: Text('Popular'),
                    //    icon: Icon(Icons.favorite)
                  ),
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
