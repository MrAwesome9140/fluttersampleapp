import 'package:flutter/material.dart';
import 'package:fluttersampleapp/models/family.dart';

class FamilyTile extends StatelessWidget {

  final Family family;
  FamilyTile({this.family});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
      child: Container(
        height: 80.0,
        child: Card(
          child: Center(
            child: ListTile(
              leading: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                child: CircleAvatar(
                  radius: 25.0,
                  backgroundImage: AssetImage("lib/assets/person.png"),
                ),
              ),              
              title: Padding(
                padding: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 0.0),
                child: Text(
                  family.fullName
                ),
              ),
              subtitle: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10.0, 3.0, 0.0, 0.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: <Widget>[ 
                      Container(
                        height: 18.0,
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 6.0, 0.0),
                        child: Text("Height: ${family.height}\n")
                      ),
                      Container(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 4.0),
                        child: Text("Weight: ${family.weight}")
                      )
                    ]
                  ),
                ),
              ),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
          ),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.black, width: 1.0),
            borderRadius: BorderRadius.circular(8.0)
          ),
        ),
      ),
    );
  }
}