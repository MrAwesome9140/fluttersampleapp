import 'package:flutter/material.dart';
import 'package:fluttersampleapp/Screens/home/home.dart';
import 'package:fluttersampleapp/Screens/home/settings_form.dart';
import 'package:fluttersampleapp/Services/auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fluttersampleapp/Screens/home/google_mapview.dart';

class LoggedIn extends StatefulWidget {
  @override
  _LoggedInState createState() => _LoggedInState();
}

class _LoggedInState extends State<LoggedIn> {

  List<Widget> _widgets = <Widget>[
    SettingsForm(),
    Home(),
    GoogleMapView()
  ];

  int selectedIndex = 1;
  final AuthService _auth = AuthService();

  void _onItemTapped(int index){
    setState(() {
      selectedIndex = index;
    });
  }

  void changeScreens(int index){
    setState(() {
      selectedIndex = index;
    });
  }

  Widget floatingActionButton() {
    return selectedIndex == 2 ? Container() : Padding(
        padding: EdgeInsetsDirectional.fromSTEB(40.0, 0.0, 0.0, 20.0),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: FloatingActionButton(
            //label: Text("Sign Out", style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600)),
            tooltip: "Sign Out",
            child: Icon(Icons.exit_to_app),
            onPressed: () async {
              Navigator.pushReplacementNamed(context, '/loading');
              await _auth.signOut();
              Navigator.pushReplacementNamed(context, '/signin');
            },
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: new List<Widget>.generate(_widgets.length, (index) {
          return new IgnorePointer(
            ignoring: index != selectedIndex,
            child: new Opacity(
              opacity: selectedIndex==index ? 1.0 : 0.0,
              child: new Navigator(
                onGenerateRoute: (RouteSettings settings) {
                  return MaterialPageRoute(
                    builder: (_) => _widgets[index]
                  );
                }
              )
            ),
          );
        }),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text("Settings", style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600)),
            backgroundColor: Colors.grey[300]
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Home", style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600)),
            backgroundColor: Colors.grey[300]
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text("Map", style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600)),
            backgroundColor: Colors.grey[300]
          )
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.red[500],
        onTap: _onItemTapped,
      ),
      floatingActionButton: floatingActionButton(),
    );
  }
}