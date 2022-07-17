import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  var logger = Logger();
  late LatLng _location;
  Future<LocationData?> _currentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    Location location = Location();

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return Future.error("فعل الموقع");
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return Future.error("Permission Denied");
      }
    }
    return await location.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<LocationData?>(
        future: _currentLocation(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapchat) {
          if (snapchat.hasData) {
            final LocationData currentLocation = snapchat.data;
            _location =
                LatLng(currentLocation.latitude!, currentLocation.longitude!);
            return _buildMap(_location);
          } else if (snapchat.hasError) {
            SnackBar(content: Text(snapchat.error.toString()));
            Navigator.of(context).pop();
          }
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 150,
                width: 150,
                child: Image.asset(
                  'assets/images/loading.gif',
                ),
              ),
              const Text("انتظر قليلا")
            ],
          ));
        },
      ),
    );
  }

  final _markers = <Marker>{};

  Widget _buildMap(LatLng currentLocation) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        GoogleMap(
          layoutDirection: TextDirection.rtl,
          initialCameraPosition: CameraPosition(
            target: LatLng(currentLocation.latitude, currentLocation.longitude),
            zoom: 19,
          ),
          onMapCreated: (controller) {
            setState(() {
              _markers.add(
                Marker(
                  markerId: const MarkerId('1'),
                  position: LatLng(_location.latitude, _location.longitude),
                ),
              );
            });
          },
          markers: _markers,
          onTap: (latLng) {
            setState(() {
              _location = LatLng(latLng.latitude, latLng.longitude);
              _markers.add(
                Marker(
                  markerId: const MarkerId('1'),
                  position: LatLng(_location.latitude, _location.longitude),
                ),
              );
              logger.d(latLng.toString());
              logger.d(_markers.length.toString());
            });
          },
          zoomControlsEnabled: false,
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pop(_location);
            },
            child: const Icon(Icons.save),
          ),
        ),
      ],
    );
  }
}
