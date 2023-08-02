import 'package:latlong2/latlong.dart';

class MarkerData {
  final double lat;
  final double lng;
  final int bookId;
  final String bookName;

  MarkerData(
      {required this.lat,
      required this.lng,
      required this.bookId,
      required this.bookName});

  LatLng getLatLng() {
    return LatLng(lat, lng);
  }

  String getMarkerText() {
    if (bookName.length > 10) {
      return '${bookName.substring(0, 9)}...';
    } else {
      return bookName;
    }
  }
}
