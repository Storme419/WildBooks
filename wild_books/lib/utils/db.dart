import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
            code
          )
      ''');
  List<Object> newData = [];
  for (int i = 0; i < data.length; i++) {
    newData.add({
      'event': data[i]['event'],
      'timestamp': data[i]['timestamp'],
      'title': data[i]['books_populated']['title'],
      'author': data[i]['books_populated']['author'],
      'image_url': data[i]['books_populated']['image_url'],
      'genre': data[i]['books_populated']['genre'],
      'code': data[i]['books_populated']['code']
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
        'latitude': events['latitude'],
        'longitude': events['longitude'],
        'name': events['users_populated']['name'],
        'note': events['user_note'],
        'comments': events['event_comments_populated']
      });
    }
  }
  return newData;
}
