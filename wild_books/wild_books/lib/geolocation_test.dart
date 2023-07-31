import 'package:flutter/material.dart';
import 'package:wild_books/geolocation_controller.dart';

class LocationTest extends StatelessWidget {
  const LocationTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Testing location'),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        ElevatedButton(
            onPressed: () => GeolocationController.instance.getLocation(),
            child: Text('Click me')),
        Text(GeolocationController.instance.error == ''
            ? 'Latitude: ${GeolocationController.instance.lat} | Longitude: ${GeolocationController.instance.long}'
            : '${GeolocationController.instance.error}'),
      ]),
    );
  }
}
