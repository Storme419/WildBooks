import 'package:flutter/material.dart';
import 'package:wild_books/model/book.dart';
import 'package:wild_books/utils/db.dart';
import 'package:wild_books/view/book_tile.dart';

enum FilterValues { all, found, released, popular }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FilterValues filterValuesView = FilterValues.all;

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
                  child: const Text(' Know more about us here.',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                )
              ]),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(6, 30, 6, 15),
              width: MediaQuery.of(context).size.width,
              height: 140,
              child: Column(children: [
                SizedBox(
                  height: 45,
                  child: TextField(
                      onChanged: (text) {
                        print(text);
                      },
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/found-book');
                          },
                          icon: const Icon(Icons.send),
                        ),
                        label: const Text(
                          'Found a book?',
                        ),
                        hintText: 'Please enter your code here',
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0))),
                      )),
                ),
                Wrap(children: [
                  const Text('Want to release a book instead? '),
                  InkWell(
                    onTap: () => Navigator.of(context).pushNamed('/add-book'),
                    child: const Text('Generate a code here'),
                  ),
                ])
              ]),
            ),
            Container(
              padding: const EdgeInsets.all(5),
              child: SegmentedButton<FilterValues>(
                segments: const [
                  ButtonSegment<FilterValues>(
                    value: FilterValues.all,
                    label: Text('All books'),
                    // icon: Icon(Icons.done_sharp)
                  ),
                  ButtonSegment<FilterValues>(
                    value: FilterValues.found,
                    label: Text('Found'),
                    //   icon: Icon(Icons.pin_drop)
                  ),
                  ButtonSegment<FilterValues>(
                    value: FilterValues.released,
                    label: Text('Released'),
                    //   icon: Icon(Icons.my_library_books)
                  ),
                  ButtonSegment<FilterValues>(
                    value: FilterValues.popular,
                    label: Text('Popular'),
                    //    icon: Icon(Icons.favorite)
                  ),
                ],
                selected: <FilterValues>{filterValuesView},
                onSelectionChanged: (Set<FilterValues> newSelection) {
                  setState(() {
                    filterValuesView = newSelection.first;
                  });
                },
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
                    // debugPrint(books.toString());
                    return ListView.builder(
                        itemCount: books.length,
                        itemBuilder: (context, index) {
                          Book book = Book(
                            title: books[index]['title'],
                            author: books[index]['author'],
                            bookCover: books[index]['image_url'],
                            timestamp:
                                DateTime.parse(books[index]['timestamp']),
                            latitude: books[index]['latitude'],
                            longitude: books[index]['longitude'],
                          );
                          return BookTile(book: book);
                        });
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
