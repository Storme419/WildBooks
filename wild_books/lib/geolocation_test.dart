import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wild_books/geolocation_controller.dart';

class LocationTest extends StatelessWidget {
  const LocationTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Testing location'),
        ),
        body: ChangeNotifierProvider<GeolocationController>(
          create: (context) => GeolocationController(),
          child: Builder(builder: (context) {
            final location = context.watch<GeolocationController>();

            String message = location.error == ''
                ? 'Latitude: ${location.lat} | Longitude: ${location.long}'
                : location.error;

            return Center(child: Text(message));
          }),
        ));
  }
}
