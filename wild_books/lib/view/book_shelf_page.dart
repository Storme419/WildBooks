import 'package:flutter/material.dart';
import 'package:wild_books/classes/BookshelfData.dart';
import 'package:wild_books/utils/db.dart';
import 'package:wild_books/view/singleBook.dart';

const hardcodedUser = 6;

class Bookshelf extends StatefulWidget {
  const Bookshelf({super.key});
  @override
  State<Bookshelf> createState() => _BookshelfState();
}

class _BookshelfState extends State<Bookshelf> {
  Future<Map<String, List<BookshelfData>>> _fetchAllBooks() async {
    List<BookshelfData> foundBooks = await getFoundByUser(hardcodedUser);
    List<BookshelfData> releasedBooks = await getReleasedByUser(hardcodedUser);
    return {'found': foundBooks, 'released': releasedBooks};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: _fetchAllBooks(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
             
              return const Center(child: CircularProgressIndicator());
            }
            final foundBooks = snapshot.data!['found']!;
            
            
            final releasedBooks = snapshot.data!['released']!;

            return ListView(
              children: <Widget>[
                SizedBox(height: 50),
                Text(
                            '   Found Books',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,)),
                
                SizedBox(
                  height: 180,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: foundBooks.length,
                    itemBuilder: (context, index) =>
                        _buildListItem(foundBooks[index]),
                  ),
                ),
                 SizedBox(height: 50),
                Text(
                            '   Released Books',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,)),
                SizedBox(
                  height: 180,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: releasedBooks.length,
                    itemBuilder: (context, index) =>
                        _buildListItem(releasedBooks[index]),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildListItem(BookshelfData book) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
       MaterialPageRoute(builder: (context) => SingleBookPage(bookId: book.bookId))
        );
        // singleBookPage(book_id);
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Image.network(
          book.bookImgUrl,
          width: 100,
        ),
      ),
    );
  }
}