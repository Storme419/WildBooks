import 'dart:math';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wild_books/classes/BookshelfData.dart';
import 'package:wild_books/classes/MarkerData.dart';
import 'package:wild_books/classes/BookData.dart';
import 'package:wild_books/classes/SingleBookData.dart';

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

Future getBooks([eventFilter]) async {
  var query =
      Supabase.instance.client.from('book_events_populated').select('''
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

  if (eventFilter != null) {
    debugPrint(eventFilter.toString());
    query = query.eq('event', eventFilter);
  }

  final data = await query;

  List<Object> newData = [];
  for (int i = 0; i < data.length; i++) {
    final events = data[i]['books_populated'];

    newData.add({
      'book_id': events['book_id'],
      'event': data[i]['event'],
      'timestamp': data[i]['timestamp'],
      'latitude': data[i]['latitude'],
      'longitude': data[i]['longitude'],
      'location': "to be disclosed",
      'title': events['title'],
      'author': events['author'],
      'image_url': events['image_url'],
      'genre': events['genre'],
      'code': events['code'],
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

Future getSingleBook2(id) async {
  final data = await Supabase.instance.client.from('books_populated').select('''
        book_id,
        title,
        author,
        isbn,
        image_url,
        timestamp,
        code,
        story_id,
        genre,
        language,
        isFound,
        lastKnownLat,
        lastKnownLong,

        book_events_populated (
          event_id,
          book_id,
          event,
          timestamp,
          latitude,
          longitude,
          user_id,
          user_note,
          users_populated (name),

          event_comments_populated (
            events_comments_id,
            comments_body,
            users_populated (name)
          )
        )
      ''').eq('book_id', id);

  final book = data[0];


  SingleBookData bookData = SingleBookData(
    book['book_id'],
    book['code'],
    book['isbn'],
    book['title'],
    book['author'],
    book['image_url'],
    book['timestamp'],
    book['isFound'],
    book['lastKnownLat'] + 0.0,
    book['lastKnownLong'] + 0.0,
    1,
    1,
    1,
    [],
  );

  return bookData;
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

Future postBook(BookData book) async {
  // TODO - take user ID as a parameter, to create an event

  final List<Map<String, dynamic>> data =
      await Supabase.instance.client.from('books_populated').insert([
    {
      'title': book.title,
      'author': book.author,
      'isbn': book.isbn,
      'image_url': book.imgUrl,
      'genre': book.genreId,
      'language': book.languageId,
      'timestamp': book.timestamp,
      'isFound': book.isFound,
      'lastKnownLat': book.lat,
      'lastKnownLong': book.lng,
      'story_id': book.storyId,
    },
  ]).select();

  final bookId = data[0]['book_id'];

  String randomLetter() {
    const String letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    return letters[Random().nextInt(letters.length - 1)];
  }

  final String code = randomLetter() +
      randomLetter() +
      bookId.toString() +
      randomLetter() +
      randomLetter();

  await Supabase.instance.client
      .from('books_populated')
      .update({'code': code}).match({'book_id': bookId});

  // TODO: add a released event using the book ID

  return code;
}

Future getReleasedByUser(userid) async {
  final data =
      await Supabase.instance.client.from('book_events_populated').select('''
        book_id, event,
          books_populated(
            image_url
          )
      ''').eq('user_id', userid);

  List<BookshelfData> newData = [];
  for (var i = 0; i < data.length; i++) {
    if (data[i]['event'] == 'released') {
      newData.add(BookshelfData(
          bookId: data[i]['book_id'],
          bookImgUrl: data[i]['books_populated']['image_url']));
    }
  }
  return newData;
}

Future getFoundByUser(userid) async {
  final data =
      await Supabase.instance.client.from('book_events_populated').select('''
        event, book_id,
        books_populated(
          image_url
        )
      ''').eq('user_id', userid);

  List<BookshelfData> newData = [];
  for (var i = 0; i < data.length; i++) {
    if (data[i]['event'] == 'found') {
      newData.add(BookshelfData(
          bookId: data[i]['book_id'],
          bookImgUrl: data[i]['books_populated']['image_url']));
    }
  }
  return newData;
}
