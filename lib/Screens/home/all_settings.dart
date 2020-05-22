import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class AllSettings extends StatefulWidget {
  @override
  _AllSettingsState createState() => _AllSettingsState();
}

class _AllSettingsState extends State<AllSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: "Account",
            tiles: [
              SettingsTile(
                title: "Your Information",
                leading: Icon(Icons.info),
                onTap: (){
                  Navigator.of(context).pushNamed("/settings");
                },
              ),
              SettingsTile(
                title: 'Profile Picture',
                leading: Icon(Icons.camera),
                onTap: (){
                  Navigator.of(context).pushNamed("/setprofilepic");
                },
              )
            ],
          )
        ],
      ),
    );
  }
}