import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:fluttersampleapp/Services/database.dart';
import 'package:fluttersampleapp/Shared/constants.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  DatabaseService _service = DatabaseService();

  String _email = "";
  String error = "";
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[800],
      appBar: AppBar(
        backgroundColor: Colors.lightGreen[300],
        elevation: 0.0,
      ),
      key: _scaffoldKey,
      body: new Builder(builder: (BuildContext contexts) {
        return Column(
          children: <Widget>[ 
            Container(
              color: Colors.yellow[800],
              height: 150.0,
              child: ClippingApp(height: 150.0, text: "Reset Password", titleColor: Colors.lightGreen[300], backgroundColor: Colors.yellow[800])
            ),
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20.0, 40.0, 20.0, 20.0),
                      child: TextFormField(
                        textCapitalization: TextCapitalization.none,
                        keyboardType: TextInputType.emailAddress,
                        decoration: textInputDecoration.copyWith(hintText: "Email"),
                        validator: (val) => val.isEmpty ? "Please enter an email" : null,
                        onChanged: (val) => setState(() => _email = val),
                      ),
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black, width: 1.0),
                        borderRadius: BorderRadius.circular(8.0)
                      ),
                      color: Colors.lightBlue[300],
                      child: Text("Send reset email"),
                      onPressed: () async {
                        if(_formKey.currentState.validate()){
                          Future temp = await _service.userResetPassword(_email);
                          if(temp==null){
                            _scaffoldKey.currentState.showSnackBar(
                              new SnackBar(
                                content: new Text("Unable to send email"),
                                duration: Duration(seconds: 3),
                              )
                            );
                          }
                          else{
                            error = "";
                            _scaffoldKey.currentState.showSnackBar(
                              new SnackBar(
                                content: new Text("Email sent!"),
                                duration: Duration(seconds: 3),
                              )
                            );
                          }
                        }
                      }
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    )
                  ],           
                )
              ),
            )
          ]
        );
        }
      ),
    );
  }
}

class ClippingApp extends StatelessWidget {

  double height;
  String text;
  Color titleColor;
  Color backgroundColor;

  ClippingApp({this.height, this.text, this.titleColor, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: ClipPath(
        clipper: CurvedBottomClipper(),
        child: Container(
          color: titleColor,
          height: height,
          child: Center(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 50.0),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 35,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic
                ),
              ),
          )),
        ),
      ),
    );
  }
}

class CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {

    final roundingHeight = size.height * 2 / 5;
    final filledRectangle =
        Rect.fromLTRB(0, 0, size.width, size.height - roundingHeight);

    final roundingRectangle = Rect.fromLTRB(
        -5, size.height - roundingHeight * 2, size.width + 5, size.height);

    final path = Path();
    path.addRect(filledRectangle);

    path.arcTo(roundingRectangle, pi, -pi, true);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // returning fixed 'true' value here for simplicity, it's not the part of actual question, please read docs if you want to dig into it
    // basically that means that clipping will be redrawn on any changes
    return true;
  }
}