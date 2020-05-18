import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';

class GoogleMapView extends StatefulWidget {
  @override
  _GoogleMapViewState createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {

  Geocoder _geocoder = Geocoder();

  GoogleMapController _controller;
  CameraPosition _currCamera;
  Set<Marker> _markers = Set<Marker>();

  LocationData currentLocation;

  Location location;

  @override
  void initState() {

    location = new Location();

    location.changeSettings(accuracy: LocationAccuracy.low);
    
    getPermissions();

    location.onLocationChanged.listen((LocationData cLoc){
      currentLocation = cLoc;
      updatePinOnMap();
    });

    setInitialLocation();
    
    super.initState();
  }

  void getPermissions() async {
    await Location().requestPermission();
    await Location().requestService();
  }

  void setInitialLocation() async {
    currentLocation = await location.getLocation();
  }

  @override
  Widget build(BuildContext context) {

    CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(0.0, 0.0),
      zoom: 16,
      tilt: 80,
      bearing: 30
    );

    if(currentLocation != null){
      initialCameraPosition = CameraPosition(
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 16,
        tilt: 80,
        bearing: 30
      );
    }


    return Scaffold(
      appBar: AppBar(

      ),
      body: GoogleMap(
        markers: _markers,
        initialCameraPosition: initialCameraPosition,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller){
          _controller = controller;
          showPinOnMap();
        },
      ),
    );
  }

  void showPinOnMap() {
    _markers.add(Marker(
      markerId: MarkerId("My Location"),
      position: LatLng(currentLocation.latitude, currentLocation.longitude),
    ));
  }

  void updatePinOnMap() async {
    CameraPosition cPosition = CameraPosition(
      zoom: 16,
      tilt: 80,
      bearing: 30,
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
    );

    _controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));

    setState(() {
      var pinPosition = LatLng(currentLocation.latitude, currentLocation.longitude);
      _markers.removeWhere((m) => m.markerId.value == "My Location");
      _markers.add(Marker(
         markerId: MarkerId("My Location"),
         position: pinPosition,
      ));
   });
}


}