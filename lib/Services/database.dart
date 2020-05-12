import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttersampleapp/models/family.dart';
import 'package:fluttersampleapp/models/user.dart';

class DatabaseService {

  final String uid;
  DatabaseService({this.uid});

  //collection refrence
  final CollectionReference aarohCollection = Firestore.instance.collection("family");

  Future updateUserData(String fullName, int age, String height, int weight) async{
    return await aarohCollection.document(uid).setData({
      'fullName': fullName,
      'age': age,
      'height': height,
      'weight': weight,
    });
  }

  //family list from snapshot

  List<Family> _familyListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return Family(
        fullName: doc.data["fullName"] ?? "",
        age: doc.data["age"] ?? 0,
        height: doc.data["height"] ?? "",
        weight: doc.data["weight"] ?? 0,
      );
    }).toList();
  }

  Future userResetPassword(String email){
    return FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  //userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    return UserData(
      uid: uid,
      height: snapshot.data["height"],
      fullName: snapshot.data["fullName"],
      age: snapshot.data["age"],
      weight: snapshot.data["weight"]
    );
  }

  //get family stream

  Stream<List<Family>> get family {
    return aarohCollection.snapshots().map(_familyListFromSnapshot);
  }

  //get user doc stream
  Stream<UserData> get userData{
    return aarohCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }

}