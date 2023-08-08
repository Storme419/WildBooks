import 'package:geocoding/geocoding.dart';

class UserLocation {
  dynamic getLocation(dynamic lat, dynamic long) async {
    try {
      List<Placemark> placemark = await placemarkFromCoordinates(lat, long);

      return placemark[0].administrativeArea;
    } catch (e) {
      print(e);
    }
  }
}
