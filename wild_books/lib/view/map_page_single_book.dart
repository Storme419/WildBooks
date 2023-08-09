import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';
import 'package:wild_books/components/BigMap.dart';
import 'package:wild_books/controller/geolocation_controller.dart';
import 'package:wild_books/view/singleBook.dart';
import 'package:wild_books/utils/db2.dart';
import 'package:url_launcher/url_launcher.dart';

class MapSingleBook extends StatefulWidget {
  const MapSingleBook({super.key, required this.bookId, required this.title});

  final int bookId;
  final String title;

  @override
  State<MapSingleBook> createState() => _MapSingleBookState();
}

class _MapSingleBookState extends State<MapSingleBook>
    with TickerProviderStateMixin {
  late final mapController = AnimatedMapController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
    curve: Curves.easeInOut,
  );

  bool isShowUnfound = true;

  String selectedBookTitle = 'Book Title';
  int selectedBookId = 1;
  bool isDrawerVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FlutterMap(
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
              future: getSingleBookMarkers(widget.bookId),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) return const PolylineLayer(polylines: []);

                final markers = snapshot.data!;

                List<LatLng> points = [];

                for (final marker in markers) {
                  points.add(marker.getLatLng());
                }  

                return PolylineLayer(
                  polylines: [
                    Polyline(
                      points: points,
                      color: Colors.blue,
                      strokeWidth: 5,
                      isDotted: true,

                    ),
                  ],
                );
              }),
          FutureBuilder(
            future: getSingleBookMarkers(widget.bookId),
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
                      builder: (context) => Column(children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 30,
                        ),
                      ]),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
