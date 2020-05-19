import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttersampleapp/models/userloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService{

  String uid;

  LocationService({this.uid});

  final CollectionReference locationCollection = Firestore.instance.collection("locations");

  Future updateUserLocation(LatLng location) async {
    return await locationCollection.document(uid).setData({
      "latitude": location.latitude,
      "longitude": location.longitude
    });
  }

   List<UserLocation> _userDataListFromSnapshot (QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return UserLocation(
        uid: doc.documentID,
        location: LatLng(doc.data["latitude"], doc.data["longitude"])
      );
    }).toList();
  }

  Stream<List<UserLocation>> get coords {
    return locationCollection.snapshots().map(_userDataListFromSnapshot);
  }
}