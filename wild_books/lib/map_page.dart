import 'package:flutter/material.dart';
import 'package:wild_books/components/BigMap.dart';

class Map extends StatelessWidget {
  const Map({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: BigMap(),
    );
  }
}