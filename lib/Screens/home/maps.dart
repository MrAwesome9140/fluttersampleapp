import 'package:flutter/material.dart';
import 'package:fluttersampleapp/Screens/home/google_mapview.dart';
import 'package:fluttersampleapp/Services/location.dart';
import 'package:fluttersampleapp/models/userloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class Maps extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return StreamProvider<List<UserLocation>>.value(
      value: LocationService().coords,
      child: GoogleMapView()
    );
  }
}