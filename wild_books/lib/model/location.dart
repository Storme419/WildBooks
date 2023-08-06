import 'package:geocoding/geocoding.dart';

class UserLocation {
  dynamic getLocation(dynamic lat, dynamic long) async {
    try {
      List<Placemark> placemark = await placemarkFromCoordinates(lat, long);

      print(placemark[0].country);
      print(placemark[0].locality);
      print(placemark[0].administrativeArea);
      print(placemark[0].postalCode);
      print(placemark[0].name);
      print(placemark[0].isoCountryCode);
      print(placemark[0].subLocality);
      print(placemark[0].subThoroughfare);
      print(placemark[0].thoroughfare);

      return placemark[0].administrativeArea;
    } catch (e) {
      print(e);
    }
  }
}
