import 'package:latlong2/latlong.dart';

class MarkerData {
  final double lat;
  final double lng;
  final int bookId;

  MarkerData({required this.lat, required this.lng, required this.bookId});

  LatLng getLatLng() {
    return LatLng(lat, lng);
  }
}
