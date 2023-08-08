import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wild_books/classes/MarkerData.dart';
import 'package:wild_books/controller/geolocation_controller.dart';

class BigMap extends StatefulWidget {
  const BigMap(
      {super.key,
      required this.markerData,
      required this.callbackMarkerDetails,
      required this.callbackHideDrawer});

  final void Function(dynamic, dynamic) callbackMarkerDetails;
  final void Function() callbackHideDrawer;
  final Future<List<MarkerData>> markerData;

  @override
  State<BigMap> createState() => _BigMapState();
}

class _BigMapState extends State<BigMap> with TickerProviderStateMixin {
  late final mapController = AnimatedMapController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
    curve: Curves.easeInOut,
  );

  @override
  void initState() {
    super.initState();
    GeolocationController.instance.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController.mapController,
      options: MapOptions(
        minZoom: 2.0,
        maxZoom: 18.0,
        center: const LatLng(51.5, -0.1),
        interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        zoom: 9.2,
        onMapReady: () {
          mapController.mapController.mapEventStream.listen((evt) {});
        },
        onTap: (tapPosition, latLng) {
          widget.callbackHideDrawer();
        },
      ),
      nonRotatedChildren: [
        Align(
          alignment: Alignment.topRight,
          child: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white,
            child: IconButton(
              onPressed: () {
                mapController.animateTo(
                  dest: LatLng(GeolocationController.instance.lat,
                      GeolocationController.instance.long),
                );
              },
              icon: const Icon(Icons.my_location),
            ),
          ),
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
        FutureBuilder(
          future: widget.markerData,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) return const MarkerLayer(markers: []);

            final markers = snapshot.data!;

            return MarkerLayer(
              markers: [
                ...markers.map(
                  (marker) => Marker(
                    point: marker.getLatLng(),
                    width: 80,
                    height: 80,
                    builder: (context) => GestureDetector(
                      onTap: () {
                        widget.callbackMarkerDetails(
                            marker.markerText, marker.markerLinkId);
                      },
                      child: Column(children: [
                        Icon(
                          Icons.location_on,
                          color: marker.isFound ? Colors.red : Colors.black,
                          size: 30,
                        ),
                        Text(
                          marker.getMarkerText(),
                          style: TextStyle(
                            color: marker.isFound ? Colors.white : Colors.black,
                            backgroundColor: marker.isFound? Colors.deepOrange : Colors.white,
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}