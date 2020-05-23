import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttersampleapp/Services/database.dart';
import 'package:fluttersampleapp/models/user.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class StorageService{

  static String curUID;
  static StreamController<bool> controller = StreamController.broadcast();

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
    controller.add(true);
    return Image.file(file);
  }

  static Map<String, Image> getAllProfilePics(){
    final Map<String, Image> images = Map<String, Image>();
    DatabaseService().family.first.then((fams) async {
      for(UserData d in fams){
        Image tempImage;
        await getCurUserImage(d.uid).then((value) => tempImage = value);
        images["${d.uid}"] = tempImage;
      }
    });
    return images;
  }

  static Map<String, BitmapDescriptor> getAllProfileIcons(){
    final Map<String, BitmapDescriptor> icons = Map<String, BitmapDescriptor>();
    DatabaseService().family.first.then((fams) async {
      for(UserData d in fams){
        String url = await urlFromUID(d.uid);
        if(url != null){
          final File markerImageFile = await DefaultCacheManager().getSingleFile(url);
          final Uint8List listOfBytes = await markerImageFile.readAsBytes();
          final ui.Codec markerImageCodec = await ui.instantiateImageCodec(listOfBytes, targetWidth: 60);
          ui.FrameInfo fi = await markerImageCodec.getNextFrame();
          final Uint8List resized =  (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
          icons[d.uid] = BitmapDescriptor.fromBytes(resized);
        }
      }
    });
    return icons;
  }

  static Future<String> urlFromUID(String uid) async {
    StorageReference ref = FirebaseStorage.instance.ref().child("images/$uid.jpg");
    if(ref == null){
      return null;
    }
    try{
      return await ref.getDownloadURL();
    }catch(e){
      return null;
    }
  }

  static Future<Image> getCurUserImage(String uid) async {
    StorageReference ref = FirebaseStorage.instance.ref().child("images/$uid.jpg");
    if(ref == null){
      return null;
    }
    try{
      final String url = await ref.getDownloadURL();
      return Image.network(url, fit: BoxFit.scaleDown);
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