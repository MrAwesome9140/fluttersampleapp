import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttersampleapp/Services/auth.dart';
import 'package:fluttersampleapp/Shared/constants.dart';
import 'package:fluttersampleapp/Shared/loading.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = "";
  String password = "";
  String error = "";
  String _fullName;
  int _age;
  String _height;
  int _weight;

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
              Navigator.pushReplacementNamed(context, "/signin");
            }, 
            icon: Icon(Icons.person), 
            label: Text("Sign In")
            )
        ],
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.brown[400],
                  height: 90.0,
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 35,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(50.0, 20.0, 50.0, 0.0),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.none,
                    decoration: textInputDecoration.copyWith(hintText: "Email"),
                    validator: (val) => val.isEmpty || !val.contains("@") ? "Enter an email":null,
                    onChanged: (val) {
                      setState(() {
                        email = val;
                      });
                    } 
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal:50.0),
                  child: TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: "Password"),
                    validator: (val) => val.length<8 ? "Enter a password 8+ chars long":null,
                    obscureText: true,
                    onChanged: (val) {
                      setState(() {
                        password = val;
                      });
                    },
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal:50.0),
                  child: TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: "Full Name"),
                    validator: (val) => val.isEmpty ? "Please enter your full name":null,
                    onChanged: (val) {
                      setState(() {
                        _fullName = val;
                      });
                    },
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal:50.0),
                  child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      decoration: textInputDecoration.copyWith(hintText: "Age"),
                      validator: (val) => val.isEmpty ? 'Please enter an age' : null,
                      onChanged:  (val) => setState(() => _age = int.parse(val))
                  ),
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal:50.0),
                  child: TextFormField(
                      decoration: textInputDecoration.copyWith(hintText: "Height (ft'inches)"),
                      validator: (val) => val.isEmpty ? "Please enter a height":null,
                      onChanged: (val) => setState(() => _height = val),
                  ),
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal:50.0),
                  child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      decoration: textInputDecoration.copyWith(hintText: "Weight (lbs)"),
                      validator: (val) => val.isEmpty ? "Please enter a weight":null,
                      onChanged: (val) => setState(() => _weight = int.parse(val)),
                    ),
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
                    "Register", 
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if(_formKey.currentState.validate()){
                      setState(() {
                        loading = true;
                      });
                      dynamic result = await _auth.registerWithEmailAndPassword(email.trim(), password.trim(), _fullName, _age, _height, _weight);
                      if(result == null){
                        setState(() {
                          //error = "Please supply a valid email";
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
      ),
    );
  }
}