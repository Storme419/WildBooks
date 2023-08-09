import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wild_books/classes/single_book.dart';
import 'package:wild_books/classes/single_book_event.dart';
import 'package:wild_books/classes/single_book_event_comment.dart';

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

  final singleBookData = SingleBook(
    title: data[0]['title'],
    author: data[0]['author'],
    imageUrl: data[0]['image_url'],
    events: [],
  );

  final eventsArr = data[0]['book_events_populated'];

  for (var i = 0; i < eventsArr.length; i++) {
    final eventData = SingleBookEvent(
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

  // List<Object> newData = [];

  // if (givenCode == data[0]['code']) {
  //   newData.add({
  //     'title': data[0]['title'],
  //     'author': data[0]['author'],
  //     'image_url': data[0]['image_url'],
  //     'code': data[0]['code'],
  //     'story_id': data[0]['story_id']
  //   });
  //   for (var i = 0; i < data[0]['book_events_populated'].length; i++) {
  //     final events = data[0]['book_events_populated'][i];
  //     newData.add({
  //       'event': events['event'],
  //       'timestamp': events['timestamp'],
  //       'location': "to be disclosed",
  //       'name': events['users_populated']['name'],
  //       'note': events['user_note'],
  //       'comments': events['event_comments_populated']
  //     });
  //   }
  // }
  // return newData;
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
