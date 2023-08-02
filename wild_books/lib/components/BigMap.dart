import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wild_books/classes/MarkerData.dart';

class BigMap extends StatefulWidget {
  const BigMap({super.key, required this.markerData});

  final List<MarkerData> markerData;

  @override
  State<BigMap> createState() => _BigMapState();
}

class _BigMapState extends State<BigMap> with TickerProviderStateMixin {

  late final mapController = AnimatedMapController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
    curve: Curves.easeInOut,
  );

  MaterialColor lovelyColour = Colors.purple;
  String markerText = 'clickable marker';


  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController.mapController,
      options: MapOptions(
        minZoom: 2.0,
        maxZoom: 18.0,
        center: const LatLng(53.2043, -1.1549),
        interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        zoom: 9.2,
        onMapReady: () {
          mapController.mapController.mapEventStream.listen((evt) {});
        },
      ),
      nonRotatedChildren: [
        Column(
          children: [
            ElevatedButton(
              onPressed: () {
                mapController.animateTo(
                    dest: const LatLng(51.509364, -0.128928), zoom: 9.2);
              },
              child: const Text('Go to London'),
            ),
            ElevatedButton(
              onPressed: () {
                mapController.animateTo(
                    dest: const LatLng(53.2043, -1.1549), zoom: 9.2);
              },
              child: const Text('Go to Warsop'),
            ),
            ElevatedButton(
              onPressed: () {
                mapController.animateTo(
                    dest: const LatLng(53.3342, -1.7837), zoom: 10);
              },
              child: const Text('Peak District'),
            ),
            ElevatedButton(
              onPressed: () {
                mapController.animateTo(
                    dest: const LatLng(55.3781, -3.4360), zoom: 5.5);
              },
              child: const Text('Zoom Out...'),
            ),
          ],
        ),
        RichAttributionWidget(
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
              onTap: () =>
                  launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
            ),
          ],
        ),
      ],
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayer(
          markers: [
            ...widget.markerData.map(
              (marker) => Marker(
                point: marker.getLatLng(),
                width: 80,
                height: 80,
                builder: (context) => GestureDetector(
                onTap: () {
                  debugPrint('you clicked a thing');
                  setState(() {
                    lovelyColour = (lovelyColour == Colors.purple
                        ? Colors.orange
                        : Colors.purple);
                    markerText = 'redirect?';
                  });
                },
                child: Column(
                  children: [
                    const Icon(Icons.location_on, color: Colors.red, size: 30),
                    Text(
                      marker.getMarkerText(),
                      style: TextStyle(
                        color: Colors.white,
                        backgroundColor: lovelyColour,
                      ),
                    ),
                  ],
                ),
              ),
              ),
            )
          ],
        ),
      ],
    );
  }
}