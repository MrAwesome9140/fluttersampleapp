import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttersampleapp/Services/storage.dart';
import 'package:path/path.dart' as p;
import 'package:settings_ui/settings_ui.dart';

class SetProfilePic extends StatefulWidget {
  @override
  _SetProfilePicState createState() => _SetProfilePicState();
}

class _SetProfilePicState extends State<SetProfilePic> {

  File file;
  File currentImage;

  @override
  Widget build(BuildContext context){

    getCurrentImage();

    Image image = currentImage == null ? null:Image.file(currentImage);

    return Column(
      children: <Widget>[
        image ?? SizedBox(height: 10.0),
        SettingsList(
          sections: [
            SettingsSection(
              tiles: [
                SettingsTile(
                  title: image == null ? "Set Profile Picture":"Change Profile Picture",
                  onTap: () async {
                    await filePicker();
                    await StorageService.uploadImage(file, context);
                    setState(() {
                      
                    });
                  },
                )
              ]
            )
          ],
        )
      ],
    );
  }

  Future<void> getCurrentImage() async {
    String curUid = StorageService.getCurUID(context);
    await StorageService.getCurUserImage(curUid).then((File f) {
      setState(() {currentImage = f;});
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