import 'package:flutter/material.dart';
import 'package:fluttersampleapp/Screens/home/settings_form.dart';
import 'package:fluttersampleapp/Services/auth.dart';
import 'package:fluttersampleapp/Services/database.dart';
import 'package:fluttersampleapp/models/family.dart';
import 'package:fluttersampleapp/models/user.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttersampleapp/Screens/home/family_list.dart';

class Home extends StatelessWidget {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {

    return StreamProvider<List<UserData>>.value(
      value: DatabaseService().family,
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Center(child: Text("Aaroh's App", style: TextStyle(fontFamily: "FrontMan", fontWeight: FontWeight.w500))),
          backgroundColor: Colors.blue[400],
          elevation: 0.0,
        ),
        body: FamilyList(),
      ),
    );
  }
}
