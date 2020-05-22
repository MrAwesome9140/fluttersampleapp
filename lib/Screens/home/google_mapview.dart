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
import 'package:flutter_swiper/flutter_swiper.dart';

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
  CameraPosition initialCameraPosition = CameraPosition(target: LatLng(0,0));
  SwiperController _swiperController = SwiperController();

  LocationService _locationService;
  List<UserLocation> locs = List<UserLocation>();
  List<UserData> peeps = List<UserData>();
  User curUser;
  LatLngBounds bounds;

  UserData currentSelected = UserData(fullName: "");
  String selectedLoc = "";

  List<Color> colors = [Colors.red, Colors.green, Colors.yellow, Colors.blue];
  List<Address> locStrings = List<Address>();

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

    address();
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
      if(locs == null){
        locs = event;
        address();
        putAllMarkersInView();
      }
      else{
        locs = event;
        address();
      }
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
              putAllMarkersInView();
            },
            onTap: (LatLng loc) {
              setState(() {
                _pillPosition = -100;
              });
            },
          ),
          userCards()
        ],
      ),
    );
  }

  Widget userCards(){
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 100,
        child: Swiper(
          controller: _swiperController,
          onIndexChanged: (int index){
            UserLocation current = locs[index] ?? null;
            CameraPosition wowo = CameraPosition(target: current.location, zoom: 14);
            _controller.animateCamera(CameraUpdate.newCameraPosition(wowo));
          },
          itemCount: locs.length,
          viewportFraction: 0.8,
          scale: 0.9,
          itemBuilder: (BuildContext context, int index) {
            return Align(
              alignment: Alignment.centerLeft,
                child: AnimatedPositioned(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: 50,
                            height: 50,
                            margin: EdgeInsets.only(left: 0.0),
                            child: ClipOval(
                              child: Icon(Icons.person_pin)
                            )
                          ),
                        ),
                        Container(
                          width: 200.0,
                          margin: EdgeInsets.only(left: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 5.0),
                                  child: Text(
                                    getUserFromUserLoc(locs[index]).fullName ?? "No name found",
                                    style: TextStyle(color: Colors.green[600], fontWeight: FontWeight.w600, fontFamily: "TypeWriter"),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                child: Text(
                                  locStrings[index].addressLine ?? "",
                                  style: TextStyle(color: Colors.blue[600], fontWeight: FontWeight.w300, fontFamily: "TypeWriter", fontSize: 10, height: 1.1),
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                            ],
                          )
                        )
                      ],
                    ),
                  ), 
                  duration: Duration(milliseconds: 200),
                  bottom: _pillPosition,
                  right: 0.0,
                  left: 0.0,
                ),
            );
          },
        ),
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

  void address(){
    List<Future<Address>> futures = new List<Future<Address>>();
    for(UserLocation uLoc in locs){
      futures.add(geocodeLocationtoAddress(uLoc.location));
    }
    Future.wait(futures).asStream().listen((event) {
      locStrings = event;
    });
  }

  void showPinsOnMap() {
    for(int i = 0; i<locs.length; i++){
      UserLocation user = locs[i];
      UserData useThis = getUserFromUserLoc(user);
      _markers.add(Marker(
        position: user.location,
        infoWindow: InfoWindow(
          title: useThis.fullName,
        ),
        markerId: MarkerId(useThis.fullName),
        onTap: () {
          currentSelected = useThis;
          var temps = geocodeLocationtoAddress(user.location);
          _pillPosition = 0;
          temps.asStream().listen((event) {
            selectedLoc = event.addressLine;
          });
          _swiperController.move(i);
        },
        //icon: icon
      ));
    }
    setState(() {
      if(first == 0 && locs.length>1){
        putAllMarkersInView();
        first++;
      }
      else if(locs.length == 1 && initialCameraPosition == null){
        _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: locs[0].location,
          zoom: 15
        )));
      }
    });
  }

  void putAllMarkersInView(){
    if(_controller != null){
      setLatLngBounds();
      CameraUpdate u2 = CameraUpdate.newLatLngBounds(bounds, 50);
      
      _controller.animateCamera(u2);
    }
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

}