import 'dart:math';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wild_books/classes/BookshelfData.dart';
import 'package:wild_books/classes/MarkerData.dart';
import 'package:wild_books/classes/BookData.dart';
import 'package:wild_books/classes/SingleBookData.dart';
import 'package:wild_books/classes/single_book.dart';
import 'package:wild_books/classes/single_book_event.dart';
import 'package:wild_books/classes/single_book_event_comment.dart';
import 'package:wild_books/utils/api.dart';

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
  var query = Supabase.instance.client.from('book_events_populated').select('''
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

  final data = await query.order('timestamp', ascending: false);

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
        title, author, image_url, code, story_id, book_id,
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

  final singleBookData = SingleBook(
    title: data[0]['title'],
    author: data[0]['author'],
    imageUrl: data[0]['image_url'],
    events: [],
    code: data[0]['code'],
    bookId: data[0]['book_id'],
  );

  final eventsArr = data[0]['book_events_populated'];

  for (var i = 0; i < eventsArr.length; i++) {
    final eventData = SingleBookEvents(
      event: eventsArr[i]['event'],
      timestamp: eventsArr[i]['timestamp'],
      // latitude: event['latitude'],
      // longitude: event['longitude'],
      location: 'to be disclosed',
      name: eventsArr[i]['users_populated']['name'],
      note: eventsArr[i]['user_note'],
      comments: [],
    );

    for (var j = 0; j < eventsArr[i]['event_comments_populated'].length; j++) {

      eventData.comments.add(SingleBookEventComment(
        // eventId: comment['event_id'],
        userName: eventsArr[i]['event_comments_populated'][j]['users_populated']
            ['name'],
        commentBody: eventsArr[i]['event_comments_populated'][j]
            ['comments_body'],
      ));
    singleBookData.events.add(eventData);
    }
  }

  return singleBookData;
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

  final description = await fetchBlurb(book['isbn']);

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
    description
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

Future addEvent(int bookId, int userId, event, double latitude,
    double longitude, user_note) async {
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
debugPrint(event);
    bool isFound = event == 'found' ? true : false;

    await Supabase.instance.client
        .from('books_populated')
        .update({'lastKnownLat': latitude, 'lastKnownLong': longitude, 'isFound': isFound})
        .match({'book_id': bookId});

    return true;
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

  Future<List<BookshelfData>> getReleasedByUser(userid) async {
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
        bookImgUrl: data[i]['books_populated']['image_url'],
        bookId: data[i]['book_id'],
      ));
    }
  }
  return newData;
}

Future<List<BookshelfData>> getFoundByUser(userid) async {
  final data =
      await Supabase.instance.client.from('book_events_populated').select('''
        book_id, event,
          books_populated(
            image_url
          )
      ''').eq('user_id', userid);

  List<BookshelfData> newData = [];
  for (var i = 0; i < data.length; i++) {
    if (data[i]['event'] == 'found') {
      newData.add(BookshelfData(
                bookImgUrl: data[i]['books_populated']['image_url'],
       
        bookId: data[i]['book_id'],
      ));
    }
  }
  
  
  return newData;
}