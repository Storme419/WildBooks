import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class GeolocationController extends ChangeNotifier {
  static GeolocationController instance = GeolocationController();

  double lat = 0.0;
  double long = 0.0;
  String error = '';
  String? currentAddress;

  GeolocationController() {
    getLocation();
  }

  getLocation() async {
    try {
      Position position = await _currentLocation();
      lat = position.latitude;
      long = position.longitude;
    } catch (e) {
      error = e.toString();
    }
    notifyListeners();
  }

  Future<Position> _currentLocation() async {
    LocationPermission permission;

    bool isEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isEnabled) {
      return Future.error('Please enable location sharing on your phone');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error('Please enable location sharing on your phone');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Please enable location sharing on your phone');
    }

    return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best)
        .timeout(Duration(seconds: 5));
  }
}
