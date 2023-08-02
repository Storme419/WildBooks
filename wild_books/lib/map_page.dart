import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:wild_books/components/BigMap.dart';
import 'package:wild_books/classes/MarkerData.dart';

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  final markerData = [
    MarkerData(
        lat: 51.6,
        lng: -0.13,
        bookId: 1,
        bookName: 'Harry Potter and the Very Long Named Book'),
    MarkerData(lat: 51.4, lng: -0.12, bookId: 2, bookName: '1984'),
    MarkerData(lat: 51.3, lng: -0.3, bookId: 3, bookName: 'The Great Gatsby'),
    MarkerData(lat: 51.7, lng: -0.3, bookId: 4, bookName: 'American Psycho'),
  ];

  String selectedBookTitle = 'Some book';
  int selectedBookId = 1;
  bool isDrawerVisible = false;

  @override
  Widget build(BuildContext context) {
    double drawerHeight = MediaQuery.of(context).size.height / 4;

    void notifyMarkerDetails(bookTitle, bookId) {
      setState(() {
        selectedBookTitle = bookTitle;
        selectedBookId = bookId;
        isDrawerVisible = true;
      });
    }

    void notifyHideDrawer() {
      setState(() {
        isDrawerVisible = false;
      });
    }

    return Scaffold(
      body: Stack(
        children: <Widget>[
          BigMap(
              markerData: markerData,
              callbackMarkerDetails: notifyMarkerDetails,
              callbackHideDrawer: notifyHideDrawer),
          AnimatedPositioned(
            left: 0,
            bottom: isDrawerVisible ? 0 : -drawerHeight,
            duration: const Duration(milliseconds: 300),
            child: MapDrawer(
                height: drawerHeight,
                bookTitle: selectedBookTitle,
                bookId: selectedBookId,
                callbackHideDrawer: notifyHideDrawer),
          ),
        ],
      ),
    );
  }
}

class MapDrawer extends StatefulWidget {
  const MapDrawer({
    super.key,
    required this.height,
    required this.bookTitle,
    required this.bookId,
    required this.callbackHideDrawer,
  });

  final double height;
  final String bookTitle;
  final int bookId;
  final void Function() callbackHideDrawer;

  @override
  State<MapDrawer> createState() => _MapDrawerState();
}

class _MapDrawerState extends State<MapDrawer> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: Container(
        color: Colors.white,
        height: widget.height,
        width: width,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Stack(
            children: <Widget>[
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(widget.bookTitle),
                  ElevatedButton(
                    onPressed: () {
                      debugPrint('navigate to ${widget.bookId}');
                    },
                    child: const Text('View this book'),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  widget.callbackHideDrawer();
                },
                icon: const Icon(Icons.close),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
