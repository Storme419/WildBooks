import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:wild_books/components/BigMap.dart';
import 'package:wild_books/components/MarkerData.dart';

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  final markerData = [
    MarkerData(lat: 51.6, lng: -0.13, bookId: 1),
    MarkerData(lat: 51.4, lng: -0.12, bookId: 1),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BigMap(markerData: markerData),
    );
  }
}