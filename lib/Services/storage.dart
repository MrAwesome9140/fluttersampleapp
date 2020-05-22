import 'dart:collection';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttersampleapp/Services/database.dart';
import 'package:fluttersampleapp/models/user.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class StorageService{

  static String curUID;


  static Future<void> uploadImage(File file, BuildContext context) async {
    getCurUID(context);
    StorageReference storageReference;
    storageReference = FirebaseStorage.instance.ref().child("images/$curUID.jpg");
    final StorageUploadTask uploadTask = storageReference.putFile(file);
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

  static Future<File> getCurUserImage(String uid) async {
    StorageReference ref = FirebaseStorage.instance.ref().child("images/$uid.jpg");
    if(ref == null){
      return null;
    }
    final String url = await ref.getDownloadURL();
    final http.Response downloadData = await http.get(url);
    final Directory systemTempDir = Directory.systemTemp;
    final File tempFile = new File("${systemTempDir.path}/$uid.jpg");
    if(tempFile.existsSync()){
      await tempFile.delete();
    }
    await tempFile.create();
    return tempFile;
  }

  static String getCurUID(BuildContext context){
    final usersV = Provider.of<User>(context) ?? [];
    curUID = usersV;
    return curUID;
  }

}