import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:waste_mangement_app/Common_widgets/common_widgets.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng? _pickedLocation;

  static const LatLng _defaultLatLng = LatLng(37.4219999, -122.0840575); // Default
  final CameraPosition _initialPosition = const CameraPosition(
    target: _defaultLatLng,
    zoom: 14.0,
  );

  Future<void> _goToCurrentLocation() async {
    final status = await Permission.location.request();
    if (!status.isGranted) return;

    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    final controller = await _controller.future;
    LatLng currentLatLng = LatLng(position.latitude, position.longitude);

    controller.animateCamera(CameraUpdate.newLatLngZoom(currentLatLng, 16.0));

  
  }

  void _onMapTapped(LatLng latLng) {
    setState(() {
      _pickedLocation = latLng;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Location"),
        actions: [
          TextButton(
            onPressed: _pickedLocation != null
                ? () => {Navigator.pop(context, _pickedLocation)}
                : null,
            child: Text(
              "Done",
              style: TextStyle(
                color: _pickedLocation != null ? Colors.black : Colors.white,
              ),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialPosition,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            compassEnabled: false, // hides compass
            mapToolbarEnabled: false, // hides directions button
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            onMapCreated: (controller) => _controller.complete(controller),
            onTap: _onMapTapped,
            markers: _pickedLocation != null
                ? {
                    Marker(
                      markerId: const MarkerId("picked"),
                      position: _pickedLocation!,
                    )
                  }
                : {},
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton(
              onPressed: _goToCurrentLocation,
              backgroundColor: WMA_Colours.greenPrimary,
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}
