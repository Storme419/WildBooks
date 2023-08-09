import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';
import 'package:quickalert/quickalert.dart';
import 'package:wild_books/controller/geolocation_controller.dart';
import 'package:wild_books/utils/db2.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class AddBookMap extends StatefulWidget {
  const AddBookMap({super.key});

  @override
  State<AddBookMap> createState() => _AddBookMapState();
}

class _AddBookMapState extends State<AddBookMap> with TickerProviderStateMixin {
  late final mapController = AnimatedMapController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
    curve: Curves.easeInOut,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(45),
                bottomLeft: Radius.circular(45))),
        title: const Text('Specify your location'),
      ),
      body: Stack(
        children: <Widget>[
          FlutterMap(
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
              const Align(
                alignment: Alignment.center,
                child: Icon(Icons.location_on, color: Colors.red, size: 30),
              ),
              Align(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child: IconButton(
                    onPressed: () {
                      GeolocationController.instance.error != ''
                          ? QuickAlert.show(
                              context: context,
                              type: QuickAlertType.error,
                              title: 'Oops...',
                              text: GeolocationController.instance.error)
                          : mapController.animateTo(
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
                    onTap: () => launchUrl(
                        Uri.parse('https://openstreetmap.org/copyright')),
                  ),
                ],
              ),
            ],
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, mapController.mapController.center);
            },
            child: const Text('here!'),
          ),
        ],
      ),
    );
  }
}

class MapDrawer extends StatefulWidget {
  const MapDrawer({
    super.key,
    required this.height,
    required this.bookTitle,
    required this.bookId,
    required this.callbackHideDrawer,
  });

  final double height;
  final String bookTitle;
  final int bookId;
  final void Function() callbackHideDrawer;

  @override
  State<MapDrawer> createState() => _MapDrawerState();
}

class _MapDrawerState extends State<MapDrawer> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: Container(
        color: Colors.white,
        height: widget.height,
        width: width,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Stack(children: <Widget>[
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(widget.bookTitle),
                  ElevatedButton(
                    onPressed: () {
                      debugPrint('navigate to ${widget.bookId}');
                    },
                    child: const Text('View this book'),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  widget.callbackHideDrawer();
                },
                icon: const Icon(Icons.close),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
