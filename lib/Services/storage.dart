import 'dart:collection';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttersampleapp/Screens/home/all_settings.dart';
import 'package:fluttersampleapp/Services/database.dart';
import 'package:fluttersampleapp/models/user.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class StorageService{

  static String curUID;

  static Future<Image> uploadImage(File file, BuildContext moreContext) async {
    try{
      await FirebaseStorage.instance.ref().child("images/$curUID.jpg").delete();
    } catch(e){
      print(e.toString());
    }
    getCurUID();
    StorageReference storageReference;
    storageReference = FirebaseStorage.instance.ref().child("images/$curUID.jpg");
    Navigator.of(moreContext).pushNamed("/loading");
    await storageReference.putFile(file).onComplete;
    Navigator.of(moreContext).pop();
    return Image.file(file);
  }

  static Map<String, File> getAllProfilePics(){
    final Map<String, File> images = Map<String, File>();
    DatabaseService().family.first.then((fams) async {
      for(UserData d in fams){
        StorageReference ref = FirebaseStorage.instance.ref().child("images/${d.uid}.jpg");
        final String url = await ref.getDownloadURL();
        final http.Response downloadData = await http.get(url);
        final Directory systemTempDir = Directory.systemTemp;
        final File tempFile = File("${systemTempDir.path}/${d.uid}.jpg");
        if(tempFile.existsSync()){
          await tempFile.delete();
        }
        await tempFile.create();
        images["${d.uid}"] = tempFile;
      }
    });
    return images;
  }

  static Future<Image> getCurUserImage(String uid) async {
    StorageReference ref = FirebaseStorage.instance.ref().child("images/$uid.jpg");
    if(ref == null){
      return null;
    }
    try{
      final String url = await ref.getDownloadURL();
      return Image.network(url, fit: BoxFit.scaleDown);
      // final http.Response downloadData = await http.get(url);
      // final Directory systemTempDir = Directory.systemTemp;
      // final File tempFile = new File("${systemTempDir.path}/$uid.jpg");
      // if(tempFile.existsSync()){
      //   await tempFile.delete();
      // }
      // await tempFile.create();
      // return tempFile;
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  static Future<String> getCurUID() async {
    final usersV = await FirebaseAuth.instance.currentUser();
    curUID = usersV.uid;
    return usersV.uid;
  }

}