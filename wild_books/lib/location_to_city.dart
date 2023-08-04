import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:wild_books/model/location.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  String country = '';
  String name = '';
  String street = '';
  String postalCode = '';

  void initState() {
    getLocation();
  }

  Future<void> getLocation() async {
    print('hello');
    try {
      List<Placemark> placemark =
          await placemarkFromCoordinates(UserLocation.lat, UserLocation.long);
      
    print(placemark[0].country);
    print(placemark[0].name);
    print(placemark[0].street);
    print(placemark[0].postalCode);

    setState(() {
      country = placemark[0].country!;
      name = placemark[0].name!;
      street = placemark[0].street!;
      postalCode = placemark[0].postalCode!;
    });
    } catch (e) {
      print(e);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Lat : " + "${UserLocation.lat}"),
            Text("Long : " + "${UserLocation.long}"),
            Text("Country : " + "$country"),
            Text("Name : " + "$name"),
            Text("Street : " + "$street"),
            Text("PostalCode : " + "$postalCode"),
          ],
        ),
      ),
    );
  }
}
