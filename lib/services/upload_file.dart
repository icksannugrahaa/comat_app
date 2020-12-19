import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';

class UploadService {
  FirebaseStorage storage = FirebaseStorage.instance;

  Future uploadImageToFirebase(BuildContext context, File _imageFile, String storage) async {
    String fileName = basename(_imageFile.path);
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('$storage / $fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    return taskSnapshot.ref.getDownloadURL();
  }

}