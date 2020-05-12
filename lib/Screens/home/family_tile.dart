import 'package:flutter/material.dart';
import 'package:fluttersampleapp/models/family.dart';

class FamilyTile extends StatelessWidget {

  final Family family;
  FamilyTile({this.family});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top:8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundImage: AssetImage("lib/assets/person.png"),
          ),
          title: Text(family.fullName),
          subtitle: Text("Height: ${family.height}\nWeight ${family.weight}"),
        )
      ),
    );
  }
}