import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';

class UploadService {
  FirebaseStorage storage = FirebaseStorage.instance;
  Reference storageReferance;

  Future uploadImageToFirebase(BuildContext context, File _imageFile, String storage) async {
    String fileName = basename(_imageFile.path);
    Reference storageReferance = FirebaseStorage.instance.ref().child('$storage / $fileName');
    UploadTask uploadTask = storageReferance.putFile(_imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    return taskSnapshot.ref.getDownloadURL();
  }

  Future deleteImageFromFirebase(String _url) async {
    var fileUrl = Uri.decodeFull(basename(_url)).replaceAll(new RegExp(r'(\?alt).*'), '');

    final Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileUrl);
        await firebaseStorageRef.delete();
  }

}