import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttersampleapp/models/family.dart';
import 'package:fluttersampleapp/models/user.dart';
import 'package:provider/provider.dart';
import 'package:fluttersampleapp/Screens/home/family_tile.dart';

class FamilyList extends StatefulWidget {
  @override
  _FamilyListState createState() => _FamilyListState();
}

class _FamilyListState extends State<FamilyList> {
  @override
  Widget build(BuildContext context) {

    Future<FirebaseUser> current = FirebaseAuth.instance.currentUser()!=null ? FirebaseAuth.instance.currentUser():null;
    FirebaseUser user;
    current.asStream().map((FirebaseUser fire) => setState(() => user = fire));

    final family = Provider.of<List<UserData>>(context) ?? [];

    return ListView.builder(
      itemCount: family.length,
      itemBuilder: (context, index){
        if(user==null || family[index].uid!=user.uid)
          return FamilyTile(family: family[index]);
        return null;
      }
    );
  }
}