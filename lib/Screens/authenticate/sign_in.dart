import 'dart:collection';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttersampleapp/Screens/authenticate/forgot_password.dart';
import 'package:fluttersampleapp/Services/auth.dart';
import 'package:fluttersampleapp/Shared/constants.dart';
import 'package:fluttersampleapp/Shared/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = "";
  String password = "";
  String error = "";

  bool saveInfo = false;

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/register");
            }, 
            icon: Icon(Icons.person), 
            label: Text("Register")
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 150.0,
              child: ClippingApp(height: 125.0, text: "Sign In", titleColor: Colors.brown[400], backgroundColor: Colors.brown[100])
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical:20.0, horizontal:50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      textCapitalization: TextCapitalization.none,
                      decoration: textInputDecoration.copyWith(hintText: "Email"),
                      validator: (val) => val.isEmpty ? "Enter an email":null,
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        });
                      } 
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(hintText: "Password"),
                      validator: (val) => val.length<8 ? "Enter a password 8+ chars long":null,
                      obscureText: true,
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                      },
                    ),
                    SizedBox(height: 20.0),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black, width: 1.0),
                        borderRadius: BorderRadius.circular(8.0)
                      ),
                      elevation: 10.0,
                      color: Colors.deepOrange[400],
                      child: Text(
                        "Sign In", 
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setString("email", email.trim());
                        prefs.setString("password", password.trim());
                        if(_formKey.currentState.validate()){
                          setState(() {
                            loading = true;
                          });
                          dynamic result = await _auth.signInWithEmailAndPassword(email.trim(), password.trim());
                          if(result == null){
                            setState(() {
                              error = "Could not sign in";
                              loading = false;
                            });
                          }
                          else{
                            Navigator.pushReplacementNamed(context, "/home");
                          }
                        }
                      }
                    ),
                    SizedBox(height: 12.0),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.75,
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Keep me signed in: ",
                              style: GoogleFonts.titanOne(fontSize: 12.0),
                            ),
                            Checkbox(
                              value: saveInfo, 
                              onChanged: (bool b){
                                setState(() {
                                  saveInfo = b;
                                });
                              },
                              activeColor: Colors.green,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 12.0),
                    Container(
                      height: 50.0,
                      width: 150.0,
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "/forgotpassword");
                          },
                          child: Text("Forgot Password?", style: TextStyle(color: Colors.lightBlue[700])),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}