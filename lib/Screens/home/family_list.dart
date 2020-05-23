import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttersampleapp/Services/storage.dart';
import 'package:fluttersampleapp/models/family.dart';
import 'package:fluttersampleapp/models/user.dart';
import 'package:provider/provider.dart';
import 'package:fluttersampleapp/Screens/home/family_tile.dart';
import 'package:fluttersampleapp/Services/database.dart';

class FamilyList extends StatefulWidget {
  @override
  _FamilyListState createState() => _FamilyListState();
}

class _FamilyListState extends State<FamilyList> {

  static Map<String, Image> images;

  @override
  void initState() {
    images = Map<String, Image>();
    setMap();
    // TODO: implement initState
    super.initState();

    StorageService.controller.stream.listen((event) { 
      setMap();
    });
  }

  Future<void> setMap() async {
    DatabaseService().family.listen((fams) async {
      for(UserData d in fams){
        Image tempImage;
        await StorageService.getCurUserImage(d.uid).then((value) => tempImage = value);
        images["${d.uid}"] = tempImage;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {

    setMap();

    Future<FirebaseUser> current = FirebaseAuth.instance.currentUser()!=null ? FirebaseAuth.instance.currentUser():null;
    FirebaseUser user;
    current.asStream().map((FirebaseUser fire) => setState(() => user = fire));

    final family = Provider.of<List<UserData>>(context) ?? [];

    return ListView.builder(
      itemCount: family.length,
      itemBuilder: (context, index){
        if(user == null || family[index].uid!=user.uid)
          return FamilyTile(family: family[index], image: images[family[index].uid]);
        return null;
      }
    );
  }
}