import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttersampleapp/Screens/home/logged_in.dart';
import 'package:fluttersampleapp/Services/database.dart';
import 'package:fluttersampleapp/Shared/constants.dart';
import 'package:fluttersampleapp/Shared/loading.dart';
import 'package:fluttersampleapp/models/user.dart';
import 'package:provider/provider.dart';
import 'package:fluttersampleapp/Services/auth.dart';

class SettingsForm extends StatefulWidget {

  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _formKey = GlobalKey<FormState>();

  //form values
  String _currentFullName;
  int _currentAge;
  String _currentHeight;
  int _currentWeight;

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    return user==null? Container():StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {

        if(snapshot.hasData){

          UserData userData = snapshot.data;

          return Scaffold(
            backgroundColor: Colors.grey[300],
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.green[600],
              title: Center(child: Text("Settings", style: TextStyle(fontFamily: "FrontMan", fontWeight: FontWeight.w500, fontSize: 18.0))),
            ),
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 40.0,
                      padding: EdgeInsetsDirectional.fromSTEB(20.0, 10.0, 20.0, 0.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Full Name:"  ,
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, fontFamily: "TypeWriter")           
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsetsDirectional.fromSTEB(20.0, 5.0, 20.0, 5.0),
                      child: TextFormField(
                        initialValue: userData.fullName,
                        decoration: textInputDecoration.copyWith(hintText: "Full Name"),
                        validator: (val) => val.isEmpty ? 'Please enter a name' : null,
                        onChanged:  (val) => setState(() => _currentFullName = val)
                      ),
                    ),
                    Container(
                      height: 40.0,
                      padding: EdgeInsetsDirectional.fromSTEB(20.0, 10.0, 20.0, 0.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Age:"  ,
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, fontFamily: "TypeWriter")           
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsetsDirectional.fromSTEB(20.0, 5.0, 20.0, 5.0),
                      child: TextFormField(
                        initialValue: userData.age.toString(),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        decoration: textInputDecoration.copyWith(hintText: "Age"),
                        validator: (val) => val.isEmpty ? 'Please enter an age' : null,
                        onChanged:  (val) => setState(() => _currentAge = int.parse(val))
                      ),
                    ),
                    Container(
                      height: 40.0,
                      padding: EdgeInsetsDirectional.fromSTEB(20.0, 10.0, 20.0, 0.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Height:"  ,
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, fontFamily: "TypeWriter")           
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsetsDirectional.fromSTEB(20.0, 5.0, 20.0, 5.0),
                      child: TextFormField(
                        initialValue: userData.height,
                        decoration: textInputDecoration.copyWith(hintText: "Height (ft'inches)"),
                        validator: (val) => val.isEmpty ? "Please enter a height":null,
                        onChanged: (val) => setState(() => _currentHeight = val),
                      ),
                    ),
                    Container(
                      height: 40.0,
                      padding: EdgeInsetsDirectional.fromSTEB(20.0, 10.0, 20.0, 0.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Weight:"  ,
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, fontFamily: "TypeWriter")           
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsetsDirectional.fromSTEB(20.0, 5.0, 20.0, 0.0),
                      child: TextFormField(
                        initialValue: userData.weight.toString(),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        decoration: textInputDecoration.copyWith(hintText: "Weight (lbs)"),
                        validator: (val) => val.isEmpty ? "Please enter a weight":null,
                        onChanged: (val) => setState(() => _currentWeight = int.parse(val)),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    RaisedButton(
                      color: Colors.pink[400],
                      child: Text(
                        "Update",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if(_formKey.currentState.validate() && user!=null){
                          await DatabaseService(uid: user.uid).updateUserData(
                            _currentFullName ?? userData.fullName, 
                            _currentAge ?? userData.age, 
                            _currentHeight ?? userData.height, 
                            _currentWeight ?? userData.weight
                          );
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text("Updated!"),
                          ));
                        }
                      },
                    )
                  ],
                )
              ),
            ),
          );
        }else{
          return Loading();
        }
      }
    );
  }
}