import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:wild_books/classes/BookData.dart';
import 'package:wild_books/controller/geolocation_controller.dart';
import 'package:wild_books/utils/alert.dart';
import 'package:wild_books/utils/api.dart';
import 'package:wild_books/utils/db.dart';
import 'package:wild_books/view/add_a_book_map.dart';

class AddBook extends StatefulWidget {
  const AddBook({super.key});

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  late FetchedBookData fetchedBookData;

  final TextEditingController isbnController = TextEditingController();
  String code = '[press button]';
  String isbn = '';
  String bookName = '';
  double lat = 0;
  double lng = 0;

  void fetch(isbn) async {
    fetchedBookData = await fetchBookData(isbn, context);
    setState(() {
      bookName = fetchedBookData.title;
    });
  }

  @override
  void initState() {
    isbnController.text = '9780151660346';
    GeolocationController.instance.getLocation();
    super.initState();
  }

  @override
  void dispose() {
    isbnController.dispose();
    super.dispose();
  }

  Future<void> getLatLngFromMap(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddBookMap()),
    );

    setState(() {
      lat = result.latitude;
      lng = result.longitude;
    });
  }

  void submitBook() async {
    if (isbn == '') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Enter a valid ISBN'),
      ));
    } else if (lat == 0 && lng == 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Pick a valid location'),
      ));
    } else {
      final bookData = BookData(
        isbn,
        bookName,
        fetchedBookData.author,
        fetchedBookData.imgUrl,
        DateTime.timestamp().toString(),
        false,
        lat,
        lng,
        1, // genreId
        1, // languageId
        1, // storyId
      );

      final codeFromDb = await postBook(bookData);

      setState(() {
        code = codeFromDb;
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Registered book successfully'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          shape: const ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(45),
                  bottomLeft: Radius.circular(45))),
          title: const Text('Release a book'),
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          actions: [
            IconButton(
              onPressed: () {
                alert(context, 'Release a book',
                    'Generate a code to write in your book when you leave it somewhere.\n\nYour ISBN can be found near the barcode of your book.');
              },
              icon: const Icon(Icons.info_outline),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(children: [
                    const SizedBox(height: 25),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        controller: isbnController,
                        decoration: const InputDecoration(
                            hintText: 'ISBN',
                            label: Text('ISBN'),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)))),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        isbn = isbnController.text;
                        fetch(isbnController.text);
                      },
                      style: ElevatedButton.styleFrom(
                          shadowColor: Colors.blueGrey,
                          elevation: 5,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      child: Ink(
                        child: Container(
                          width: 120,
                          height: 30,
                          alignment: Alignment.center,
                          child: const Text(
                            'Find my book',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      bookName != '' ? 'Book title: $bookName' : '',
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 25),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      ElevatedButton(
                          onPressed: () {
                            GeolocationController.instance.error != ''
                                ? QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.error,
                                    title: 'Oops...',
                                    text: GeolocationController.instance.error)
                                : setState(() {
                                    lat = GeolocationController.instance.lat;
                                    lng = GeolocationController.instance.long;
                                  });
                          },
                          style: ElevatedButton.styleFrom(
                              shadowColor: Colors.blueGrey,
                              elevation: 5,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          child: Ink(
                            child: Container(
                              width: 120,
                              height: 30,
                              alignment: Alignment.center,
                              child: const Text(
                                'Get my location',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            getLatLngFromMap(context);
                          },
                          style: ElevatedButton.styleFrom(
                              shadowColor: Colors.blueGrey,
                              elevation: 5,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          child: Ink(
                            child: Container(
                              width: 120,
                              height: 30,
                              alignment: Alignment.center,
                              child: const Text(
                                'Find on map',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          )),
                    ]),
                    const SizedBox(
                      height: 30,
                    ),
                    Text('lat: ${lat.toString()}',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600)),
                    Text('lng: ${lng.toString()}',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 25),
                    ElevatedButton(
                      onPressed: () {
                        submitBook();
                      },
                     style: ElevatedButton.styleFrom(
                              shadowColor: Colors.blueGrey,
                              elevation: 5,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          child: Ink(
                            child: Container(
                              width: 120,
                              height: 30,
                              alignment: Alignment.center,
                              child: const Text(
                                'Get my code',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          )
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text('Code: $code',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600)),
                  ]))),
        ));
  }
}







/* 
**************
previous code:
**************

Scaffold(
      appBar: AppBar(
        title: const Text('Add a book'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Column(children: [
        Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: SizedBox(
              child: ElevatedButton(
            child: Text('Generate your book code'),
            onPressed: () {
              setState(() {
                id = Random.secure().nextInt(5170000);
              });
            },
          )),
        ),
        SizedBox(
            child:
                Text('Please write this code on the first page of you book:')),
        SizedBox(
            child: Text(
          id.toString(),
          style: TextStyle(fontWeight: FontWeight.w600),
        )),
      ]),
    ); */