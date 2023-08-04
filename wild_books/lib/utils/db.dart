import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> initSupabase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://lmuadjmjcowajbxdbqmu.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxtdWFkam1qY293YWpieGRicW11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTA3OTcyNjksImV4cCI6MjAwNjM3MzI2OX0.SDDdTS9Smvk3whG2pGtIyVohsBuhujNVbxV4MOecoH8',
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
            code
          )
      ''');
  List<Object> newData = [];
  for (int i = 0; i < data.length; i++) {
    final events = data[i]['books_populated'];

    newData.add({
      'event': data[i]['event'],
      'timestamp': data[i]['timestamp'],
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
        title, author, image_url, code,
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
