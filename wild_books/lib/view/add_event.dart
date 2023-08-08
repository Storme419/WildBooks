import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:wild_books/controller/geolocation_controller.dart';
import 'package:wild_books/utils/db.dart';
import 'package:wild_books/view/add_a_book_map.dart';

class AddEvent extends StatefulWidget {
  const AddEvent(
      {super.key,
      required this.title,
      required this.event,
      required this.bookId,
      required this.userId});

  final String title;
  final String event;
  final int bookId;
  final int userId;

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final TextEditingController commentController = TextEditingController();

  double lat = 0;
  double lng = 0;

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

  void submitEvent() async {
    if (commentController.text == '') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Enter a comment'),
      ));
    } else if (lat == 0 && lng == 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Pick a valid location'),
      ));
    } else {
      final bool isEventPosted = await addEvent(widget.bookId, widget.userId, widget.event, lat, lng,
          commentController.text);

      // patch book lat/long and isFound state

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Added event successfully'),
      ));

      Navigator.of(context).pop(isEventPosted);
    }
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Card(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        controller: commentController,
                        maxLines: 3, //or null
                        decoration: InputDecoration.collapsed(
                            hintText: "Enter a comment here"),
                      ),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                      child: const Text('get my location'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        getLatLngFromMap(context);
                      },
                      child: const Text('find on map'),
                    ),
                  ],
                ),
                Text('lat: ${lat.toString()}'),
                Text('lng: ${lng.toString()}'),
                SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () {
                    submitEvent();
                  },
                  child: Text(widget.title),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
