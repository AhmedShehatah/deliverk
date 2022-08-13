import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';

// ignore: must_be_immutable
class MapShowScreen extends StatefulWidget {
  MapShowScreen({Key? key, this.latLng}) : super(key: key);
  LatLng? latLng;
  @override
  State<MapShowScreen> createState() => _MapShowScreenState();
}

class _MapShowScreenState extends State<MapShowScreen> {
  final _markers = <Marker>{};

  @override
  Widget build(BuildContext context) {
    var latLng = ModalRoute.of(context)?.settings.arguments as LatLng?;
    Logger().d(latLng);
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: latLng ?? widget.latLng!,
        zoom: 19,
      ),
      onMapCreated: (controller) {
        setState(() {
          _markers.add(
            Marker(
              markerId: const MarkerId('1'),
              position: latLng ?? widget.latLng!,
            ),
          );
        });
      },
      markers: _markers,
    );
  }
}
