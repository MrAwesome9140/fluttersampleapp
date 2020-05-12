import 'package:flutter/material.dart';
import 'package:fluttersampleapp/Services/auth.dart';
import 'package:fluttersampleapp/Shared/constants.dart';
import 'package:fluttersampleapp/Shared/loading.dart';

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

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
        backgroundColor: Colors.brown[100],
        appBar: AppBar(
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          title: Text("Sign in to Aaroh's App"),
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
        body: Container(
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
                  color: Colors.pink[400],
                  child: Text(
                    "Sign In", 
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if(_formKey.currentState.validate()){
                      setState(() {
                        loading = true;
                      });
                      dynamic result = await _auth.signInWithEmailAndPassword(email.trim(), password.trim());
                      if(result == null){
                        setState(() {
                          error = "could not sign in";
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
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 14.0),
                )
              ],
            ),
          ),
        ),
    );
  }
}