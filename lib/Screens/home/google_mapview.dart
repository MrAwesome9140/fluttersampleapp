import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geolocation.dart';

class GoogleMapView extends StatefulWidget {
  @override
  _GoogleMapViewState createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {

  static Position _position;
  static final Geolocator _geolocator = Geolocator()..forceAndroidLocationManager;
  Completer<GoogleMapController> _controller = Completer();

  StreamSubscription<Position> positionStream = _geolocator.getPositionStream(LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10)).listen((Position position) {
    _position = position ?? Position(latitude: 0, longitude: 0);
  });

  @override
  Widget build(BuildContext context) {
    _updateCurrentLocation();
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: _position==null? LatLng(0.0, 0.0):LatLng(_position.latitude, _position.longitude)),
        mapToolbarEnabled: true,
        mapType: MapType.normal,
        myLocationButtonEnabled: true,
        onMapCreated: (GoogleMapController controller){
          _controller.complete(controller);
        },
      ),
    );
  }

  static void _updateCurrentLocation() async {
   
  }
}