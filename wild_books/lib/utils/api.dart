import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:wild_books/classes/BookData.dart';

const String baseUrl = 'https://www.googleapis.com/books/v1/volumes';

Future fetchBookData(isbn, context) async {
  final response = await http.get(Uri.parse('$baseUrl?q=isbn:$isbn'));

  if (response.statusCode == 200) {
    final bookData = jsonDecode(response.body);

    if (bookData['totalItems'] > 0) {
      final title = bookData['items'][0]['volumeInfo']['title'];
      final author = bookData['items'][0]['volumeInfo']['authors'][0];
      //final blurb = bookData['items'][0]['volumeInfo']['description'];
      final imgUrl =
          bookData['items'][0]['volumeInfo']['imageLinks']['thumbnail'];

      return FetchedBookData(isbn, title, author, imgUrl);
    } else {
      throw Exception('no books found');
    }
  } else {
    throw Exception('no repsonse from books api');
  }
}

class FetchedBookData {
  final String isbn;
  final String title;
  final String author;
  final String imgUrl;

  FetchedBookData(
    this.isbn,
    this.title,
    this.author,
    this.imgUrl,
  );
}

Future fetchBlurb(isbn) async {
  final response = await http.get(Uri.parse('$baseUrl?q=isbn:$isbn'));

  if (response.statusCode == 200) {
    final bookData = jsonDecode(response.body);

    if (bookData['totalItems'] > 0) {
      final String blurb = bookData['items'][0]['volumeInfo']['description'];

      return blurb;
    } else {
      throw Exception('no books found');
    }
  } else {
    throw Exception('no repsonse from books api');
  }
}