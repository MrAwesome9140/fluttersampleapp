import 'package:flutter/material.dart';
import 'package:fluttersampleapp/Screens/authenticate/register.dart';
import 'package:fluttersampleapp/Screens/authenticate/sign_in.dart';
import 'package:fluttersampleapp/Screens/home/all_settings.dart';
import 'package:fluttersampleapp/Screens/home/logged_in.dart';
import 'package:fluttersampleapp/Screens/home/set_profile_pic.dart';
import 'package:fluttersampleapp/Screens/home/settings_form.dart';
import 'package:fluttersampleapp/Screens/wrapper.dart';
import 'package:fluttersampleapp/Services/auth.dart';
import 'package:fluttersampleapp/Shared/loading.dart';
import 'package:fluttersampleapp/models/user.dart';
import 'package:provider/provider.dart';
import 'package:fluttersampleapp/Screens/home/home.dart';
import 'Screens/authenticate/forgot_password.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttersampleapp/Services/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  var email;
  var password;

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: LoadingPage(),
        routes: {
          '/loading': (context) => Loading(),
          '/home': (context) => LoggedIn(),
          '/signin': (context) => SignIn(),
          '/register': (context) => Register(),
          '/settings': (context) => SettingsForm(),
          '/forgotpassword': (context) => ForgotPassword(),
          '/setprofilepic': (context) => SetProfilePic(),
          '/allSettings': (context) => AllSettings()
        },
      ),
    );
  }

  Future<void> setPrefs() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.getInstance().asStream().listen((event) {
      email = event.getString("email");
      password = event.getString("password");
    });
  }
}

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {

  @override
  void initState(){
    super.initState();
    loadPage();
  }

  void loadPage() async {
    setPrefs().then((SharedPreferences pref) async {
      String email = pref.getString("email");
      String password = pref.getString("password");
      if(email != null && password != null){
        await AuthService().signInWithEmailAndPassword(email, password);
        Navigator.of(context).pushReplacementNamed("/home");
      }
      else{
        Navigator.of(context).pushReplacementNamed("/signin");
      }
    });
  }

  Future<SharedPreferences> setPrefs(){
    WidgetsFlutterBinding.ensureInitialized();
    return SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Loading()
    );
  }


}