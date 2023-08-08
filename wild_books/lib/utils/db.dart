import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wild_books/classes/MarkerData.dart';

Future<void> initSupabase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://lmuadjmjcowajbxdbqmu.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxtdWFkam1qY293YWpieGRicW11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTA3OTcyNjksImV4cCI6MjAwNjM3MzI2OX0.SDDdTS9Smvk3whG2pGtIyVohsBuhujNVbxV4MOecoH8',
    authFlowType: AuthFlowType.pkce,
  );
}

final supabase = Supabase.instance.client;

Future getBooks() async {
  final data =
      await Supabase.instance.client.from('book_events_populated').select('''
        event, timestamp, latitude, longitude, 
        books_populated(
            title,
            author,
            image_url,
            genre,
            code,
            book_id
          )
      ''');
  List<Object> newData = [];
  for (int i = 0; i < data.length; i++) {
    final events = data[i]['books_populated'];

    newData.add({
      'event': data[i]['event'],
      'timestamp': data[i]['timestamp'],
      'latitude': data[i]['latitude'],
      'longitude': data[i]['longitude'],
      'location': "to be disclosed",
      'title': events['title'],
      'author': events['author'],
      'image_url': events['image_url'],
      'genre': events['genre'],
      'code': events['code']
    });
  }

  return newData;
}

Future getSingleBook(givenCode) async {
  final data = await Supabase.instance.client.from('books_populated').select('''
        title, author, image_url, code, story_id,
        book_events_populated (
         event,
         timestamp,
         latitude,
         longitude,
         user_note,
         users_populated (name),
         event_comments_populated (
          comments_body,
          users_populated (name)
         )
        )
      ''').eq('code', givenCode);

  List<Object> newData = [];

  if (givenCode == data[0]['code']) {
    newData.add({
      'title': data[0]['title'],
      'author': data[0]['author'],
      'image_url': data[0]['image_url'],
      'code': data[0]['code'],
      'story_id': data[0]['story_id']
    });
    for (var i = 0; i < data[0]['book_events_populated'].length; i++) {
      final events = data[0]['book_events_populated'][i];
      newData.add({
        'event': events['event'],
        'timestamp': events['timestamp'],
        'location': "to be disclosed",
        'name': events['users_populated']['name'],
        'note': events['user_note'],
        'comments': events['event_comments_populated']
      });
    }
  }
  return newData;
}

Future getStory(givenStoryId) async {
  final data = await Supabase.instance.client.from('story_junction').select('''
        story_id, 
        books_populated(
          title,
          author,
          image_url),
        story_comments_populated (
          body,
          timestamp,
          users_populated (name)
          )
        ''').eq('story_id', givenStoryId);

  List<Object> newData = [];
  final story = data[0]['books_populated'][0];
  newData.add({
    'title': story['title'],
    'author': story['author'],
    'image_url': story['image_url'],
    'story_id': data[0]['story_id'],
    'comments': data[0]['story_comments_populated']
  });
  return newData;
}

Future<List<MarkerData>> getAllBookMarkers(bool showUnfound) async {
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

void addEvent(int bookId, int userId, event, double latitude, double longitude,
    user_note) async {
  String timestamp = DateTime.timestamp().toString();
  try {
    await Supabase.instance.client.from('book_events_populated').insert({
      'book_id': bookId,
      'user_id': userId,
      'event': event,
      'timestamp': timestamp,
      'latitude': latitude,
      'longitude': longitude,
      'user_note': user_note
    });
  } on PostgrestException catch (error) {
    debugPrint(error.message);
  } catch (e) {
    debugPrint(e.toString());
  }
}

void addEventComment(int event_id, int user_id, body) async {
  String timestamp = DateTime.timestamp().toString();
  try {
    await Supabase.instance.client.from('event_comments_populated').insert({
     // 'events_comments_id': 31,
      'event_id': event_id,
      'timestamp': timestamp,
      'user_id': user_id,
      'comments_body': body,
    });
  } on PostgrestException catch (error) {
    debugPrint(error.message);
  } catch (e) {
    debugPrint(e.toString());
  }
}

void addStoryComment(int story_id, int user_id, isbn, body) async {
  String timestamp = DateTime.timestamp().toString();
  try {
    await Supabase.instance.client.from('story_comments_populated').insert({
     // 'story_comments_id': 36,
      'isbn': isbn,
      'story_id': story_id,
      'timestamp': timestamp,
      'user_id': user_id,
      'body': body,
    });
  } on PostgrestException catch (error) {
    debugPrint(error.message);
  } catch (e) {
    debugPrint(e.toString());
  }
}
