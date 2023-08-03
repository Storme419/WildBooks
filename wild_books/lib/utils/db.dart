import 'package:flutter/material.dart';
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

//book cover
//title
//author
//event column from events table
//user id for user name from events table
//timestamp from events table
//location from events table
//need username from joining table to user

Future getBooks() async {
  final data =
      await Supabase.instance.client.from('book_events_populated').select('''
        event, timestamp, latitude, longitude,
        books_populated(
            title,
            author,
            image_url,
            genre
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
      'genre': data[i]['books_populated']['genre']
    });
  }
  return newData;
}
