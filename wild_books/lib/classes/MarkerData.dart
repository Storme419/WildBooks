import 'package:latlong2/latlong.dart';

class MarkerData {
  final double lat;
  final double lng;
  final int markerLinkId;
  final String markerText;
  final bool isFound;

  MarkerData(
      {required this.lat,
      required this.lng,
      required this.markerLinkId,
      required this.markerText,
      required this.isFound});

  LatLng getLatLng() {
    return LatLng(lat, lng);
  }

  String getMarkerText() {
    if (markerText.length > 10) {
      return '${markerText.substring(0, 9)}...';
    } else {
      return markerText;
    }
  }
}