import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttersampleapp/models/family.dart';
import 'package:provider/provider.dart';
import 'package:fluttersampleapp/Screens/home/family_tile.dart';

class FamilyList extends StatefulWidget {
  @override
  _FamilyListState createState() => _FamilyListState();
}

class _FamilyListState extends State<FamilyList> {
  @override
  Widget build(BuildContext context) {

    final family = Provider.of<List<Family>>(context) ?? [];

    return ListView.builder(
      itemCount: family.length,
      itemBuilder: (context, index){
        return FamilyTile(family: family[index]);
      }
    );
  }
}