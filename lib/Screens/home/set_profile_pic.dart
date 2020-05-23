import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttersampleapp/Screens/home/all_settings.dart';
import 'package:fluttersampleapp/Services/storage.dart';
import 'package:path/path.dart' as p;
import 'package:settings_ui/settings_ui.dart';

class SetProfilePic extends StatefulWidget {
  @override
  _SetProfilePicState createState() => _SetProfilePicState();
}

class _SetProfilePicState extends State<SetProfilePic> {

  File file;
  Image currentImage;

  @override
  void initState() {
    super.initState();
    getCurrentImage();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Container(
              height: 400.0,
              child: currentImage != null ? currentImage : SizedBox(height: 0.0),
            ),
            Expanded(
              child: SettingsList(
                sections: [
                  SettingsSection(
                    title: "Picture Settings",
                    tiles: [
                      SettingsTile(
                        title: currentImage == null ? "Set Profile Picture":"Change Profile Picture",
                        onTap: () async {
                          await filePicker();
                          Image temp = await StorageService.uploadImage(file, context);
                          setState(() {
                            currentImage = temp;
                          });
                        },
                      )
                    ]
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> getCurrentImage() async {
    String curUID;
    await StorageService.getCurUID().then((value) => curUID = value);
    await StorageService.getCurUserImage(curUID).then((Image f) {
      if(this.mounted){
        setState(() {currentImage = f;});
      }
    });
  }

  Future<void> filePicker() async {
    try{
      file = await FilePicker.getFile(type: FileType.image);
      setState(() {
      });
    } on PlatformException catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Sorry...'),
            content: Text('Unsupported exception: $e'),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
      );
    }
  }

}