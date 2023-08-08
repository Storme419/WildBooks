import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wild_books/classes/MarkerData.dart';

Future <List<MarkerData>> getAllBookMarkers(bool showUnfound) async {
  var query = Supabase.instance.client.from('books_populated').select('''
        lastKnownLat, lastKnownLong, book_id, title, isFound
      ''');

  if (!showUnfound) query = query.eq('isFound', true);
  final data = await query;

  final List<MarkerData> markerDataArr = [];

  for (final marker in data) {
    final markerData = MarkerData(
      lat: marker['lastKnownLat'].toDouble(),
      lng: marker['lastKnownLong'].toDouble(),
      markerLinkId: marker['book_id'],
      markerText: marker['title'],
      isFound: marker['isFound'],
    );

    markerDataArr.add(markerData);
  }

  return markerDataArr;
}


// postNewEvent() {
// 
//  if it is a 'released' event
//  set 'isFound' false so it appears on map
//  update last known lat/long 
// }