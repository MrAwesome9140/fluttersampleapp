import 'dart:async';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttersampleapp/Services/database.dart';
import 'package:fluttersampleapp/Services/location.dart';
import 'package:fluttersampleapp/models/user.dart';
import 'package:fluttersampleapp/models/userloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as lmao;
import 'package:geocoder/geocoder.dart';
import 'package:provider/provider.dart';
import 'package:async/async.dart';
import 'dart:math' as math;

class GoogleMapView extends StatefulWidget {
  @override
  _GoogleMapViewState createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {

  Geocoder _geocoder = Geocoder();

  GoogleMapController _controller;
  CameraPosition _currCamera;
  Set<Marker> _markers = Set<Marker>();
  BitmapDescriptor icon;

  LocationService _locationService;
  List<UserLocation> locs = List<UserLocation>();
  List<UserData> peeps = List<UserData>();
  User curUser;
  LatLngBounds bounds;

  UserData currentSelected = UserData(fullName: "");
  String selectedLoc = "";

  List<Color> colors = [Colors.red, Colors.green, Colors.yellow, Colors.blue];

  lmao.LocationData currentLocation;
  lmao.Location location;

  double _pillPosition = -100;
  int first = 0;

  @override
  void initState() {

    if(curUser != null)
      _locationService = LocationService(uid: curUser.uid);
    else
      _locationService = LocationService();

    location = new lmao.Location();
    location.changeSettings(accuracy: lmao.LocationAccuracy.high);
    
    getPermissions();

    location.onLocationChanged.listen((cLoc){
      if(_locationService != null && curUser != null && _locationService.uid != null){
        _locationService.updateUserLocation(LatLng(cLoc.latitude, cLoc.longitude));
      }
      currentLocation = cLoc;
      showPinsOnMap();
    });

    setInitialLocation();
    setStreams();
    
    super.initState();
  }

  void getPermissions() async {
    await lmao.Location().requestPermission();
    await lmao.Location().requestService();
  }

  void setInitialLocation() async {
    currentLocation = await location.getLocation();
    if(_locationService != null && currentLocation != null && curUser != null && _locationService.uid != null)
      _locationService.updateUserLocation(LatLng(currentLocation.latitude, currentLocation.longitude));
  }

  void setStreams() async {
    LocationService().coords.listen((event) {
      locs = event;
    });

    DatabaseService().family.listen((event) { 
      peeps = event;
    });
  }

  @override
  Widget build(BuildContext context) {

    final usersV = Provider.of<User>(context) ?? [];

    setState(() {
      curUser = usersV;
    });

    if(curUser != null)
      _locationService = LocationService(uid: curUser.uid);
    else
      _locationService = LocationService();

    CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(0.0, 0.0),
      zoom: 15,
      tilt: 80,
      bearing: 30
    );

    if(currentLocation != null){
      initialCameraPosition = CameraPosition(
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 15,
        tilt: 80,
        bearing: 30
      );
    }


    return Scaffold(
      body: Stack(
        children: <Widget>[ 
          GoogleMap(
            markers: _markers,
            initialCameraPosition: initialCameraPosition,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller){
              _controller = controller;
              showPinsOnMap();
            },
            onTap: (LatLng loc) {
              setState(() {
                _pillPosition = -100;
              });
            },
          ),
          AnimatedPositioned(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.all(8.0),
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.blue[200],
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      blurRadius: 20,
                      offset: Offset.zero,
                      color: Colors.grey.withOpacity(0.5)
                    )
                  ]
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 50,
                      height: 50,
                      margin: EdgeInsets.only(left: 10.0),
                      child: ClipOval(
                        child: Icon(Icons.person_pin)
                      )
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                                child: Text(
                                  currentSelected.fullName,
                                  style: TextStyle(color: Colors.green[600], fontWeight: FontWeight.w600, fontFamily: "TypeWriter"),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                              child: Text(
                                selectedLoc,
                                style: TextStyle(color: Colors.blue[600], fontWeight: FontWeight.w300, fontFamily: "TypeWriter", fontSize: 10),
                              ),
                            ),
                          ],
                        )
                      ),
                    )
                  ],
                ),
              ),
            ), 
            duration: Duration(milliseconds: 200),
            bottom: _pillPosition,
            right: 0.0,
            left: 0.0,
          )
        ],
      ),
    );
  }

  UserData getUserFromUserLoc(UserLocation user){
    for(UserData data in peeps){
      if(data.uid == user.uid)
        return data;
    }
    return null;
  }

  Future<Address> geocodeLocationtoAddress(LatLng loc) async {
    final Coordinates coords = Coordinates(loc.latitude, loc.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coords);
    return addresses.first;
  }

  void showPinsOnMap() {
    int temp = 0;
    for(UserLocation user in locs){
      UserData useThis = getUserFromUserLoc(user);
      getClusterMarker(colors[temp], 150, useThis.fullName).asStream().listen((event) { 
        icon = event;
      });
      temp++;
      _markers.add(Marker(
        position: user.location,
        infoWindow: InfoWindow(
          title: useThis.fullName,
        ),
        markerId: MarkerId(useThis.fullName),
        onTap: () {
          currentSelected = useThis;
          var temp = geocodeLocationtoAddress(user.location);
          _pillPosition = 0;
          temp.asStream().listen((event) {
            selectedLoc = event.addressLine;
          });
        },
        //icon: icon
      ));
    }
    setState(() {
      if(first == 0 && locs.length>1){
        putAllMarkersInView();
        first++;
      }
      else if(locs.length == 1){
        _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: locs[0].location,
          zoom: 15
        )));
      }
    });
  }

  void putAllMarkersInView(){
    setLatLngBounds();
    CameraUpdate u2 = CameraUpdate.newLatLngBounds(bounds, 50);
    _controller.animateCamera(u2);
  }

  void setLatLngBounds(){
    double southwestLat = double.maxFinite;
    double southwestLong = double.maxFinite;
    double northeastLat = -200.0;
    double northeastLong = -200.0;
    for(UserLocation user in locs){
      double userLat = user.location.latitude;
      double userLong = user.location.longitude;
      southwestLat = math.min(southwestLat, userLat);
      southwestLong = math.min(southwestLong, userLong);
      northeastLat = math.max(northeastLat, userLat);
      northeastLong = math.max(northeastLong, userLong);
    }
    bounds = LatLngBounds(southwest: LatLng(southwestLat, southwestLong), northeast: LatLng(northeastLat, northeastLong));
  }

  Future<BitmapDescriptor> getClusterMarker(Color clusterColor, int width, String fullName) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = clusterColor;
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final double radius = width / 2;

    canvas.drawCircle(
      Offset(radius, radius),
      radius,
      paint,
    );

    textPainter.text = TextSpan(
      text: fullName,
      style: TextStyle(
        fontSize: radius - 5,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );

    textPainter.layout();

    textPainter.paint(
      canvas,
      Offset(
        radius - textPainter.width / 2,
        radius - textPainter.height / 2,
      ),
    );

    final image = await pictureRecorder.endRecording().toImage(
      radius.toInt() * 2,
      radius.toInt() * 2,
    );

    final data = await image.toByteData(format: ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }


}