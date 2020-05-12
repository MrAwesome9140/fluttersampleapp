import 'package:flutter/material.dart';
import 'package:fluttersampleapp/Screens/authenticate/register.dart';
import 'package:fluttersampleapp/Screens/authenticate/sign_in.dart';
import 'package:fluttersampleapp/Screens/wrapper.dart';
import 'package:fluttersampleapp/Services/auth.dart';
import 'package:fluttersampleapp/Shared/loading.dart';
import 'package:fluttersampleapp/models/user.dart';
import 'package:provider/provider.dart';
import 'package:fluttersampleapp/Screens/home/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: SignIn(),
        routes: {
          '/loading': (context) => Loading(),
          '/home': (context) => Home(),
          '/signin': (context) => SignIn(),
          '/register': (context) => Register()
        },
      ),
    );
  }
}