import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wild_books/classes/MarkerData.dart';

Future <List<MarkerData>> getAllBookMarkers(bool showUnfound) async {
  var query = Supabase.instance.client.from('books_populated').select('''
        lastKnownLat, lastKnownLong, book_id, title, isFound
      ''');

  if (!showUnfound) query = query.eq('isFound', false);
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


Future <List<EventMarkerData>> getSingleBookMarkers(int bookId) async {
  var data = await Supabase.instance.client.from('books_populated').select('''
        book_events_populated (
          event,
          latitude,
          longitude
          )
      ''').eq('book_id', bookId);


  final List<EventMarkerData> markerDataArr = [];

  final events = data[0]['book_events_populated'];

  for (final event in events) {
    final markerData = EventMarkerData(
      lat: event['latitude'].toDouble(),
      lng: event['longitude'].toDouble(),
    );

    markerDataArr.add(markerData);
  }

  return markerDataArr;
}

