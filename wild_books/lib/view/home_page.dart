import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:wild_books/model/book.dart';
import 'package:wild_books/utils/db.dart';
import 'package:wild_books/view/book_tile.dart';

enum FilterValues { all, found, released }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FilterValues filterValuesView = FilterValues.all;
  late String code;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              alignment: Alignment.topRight,
              padding: const EdgeInsets.fromLTRB(5, 10, 10, 10),
              child: FloatingActionButton(
                  mini: true,
                  shape: CircleBorder(side: BorderSide.none),
                  tooltip: 'Goes to about us page',
                  onPressed: () {
                    Navigator.of(context).pushNamed('/about-us');
                  },
                  child: Icon(Icons.question_mark_rounded)),
            ),
            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.fromLTRB(6, 15, 6, 15),
                width: MediaQuery.of(context).size.width * 0.6,
                height: 120,
                child: Column(children: [
                  SizedBox(
                    height: 45,
                    child: TextField(
                        textCapitalization: TextCapitalization.characters,
                        onChanged: (text) {
                          code = text;
                        },
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () async {
                              try {
                                final result = await getSingleBook(code);
                                if (result[0]['code'] == code) {
                                  //  Navigator.of(context).pushNamed('/found-book');
                                }
                              } catch (e) {
                                QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.error,
                                  title: 'Oops...',
                                  text:
                                      "Invalid code. Please try again or generate a new code.",
                                );
                              }
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
                  // Wrap(children: [
                  //   const Text('Want to release a book instead? '),
                  //   InkWell(
                  //     onTap: () => Navigator.of(context).pushNamed('/add-book'),
                  //     child: const Text('Generate a code here'),
                  //   ),
                  // ])
                ]),
              ),
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
                ],
                selected: <FilterValues>{filterValuesView},
                onSelectionChanged: (Set<FilterValues> newSelection) async {
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
