import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService{

  String uid;

  LocationService({this.uid});

  final CollectionReference locationCollection = Firestore.instance.collection("locations");

  Future _updateUserLocation(LatLng location) async {
    return await locationCollection.document(uid).setData({
      "latitude": location.latitude,
      "longitude": location.longitude
    });
  }

   List<LatLng> _userDataListFromSnapshot (QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return LatLng(double.parse(doc.data["latitude"]), double.parse(doc.data["longitude"]));
    }).toList();
  }

    Stream<List<LatLng>> get coords {
    return locationCollection.snapshots().map(_userDataListFromSnapshot);
  }

}