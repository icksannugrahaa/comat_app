import 'package:cloud_firestore/cloud_firestore.dart';
class DatabaseService {
  final String uid;
  final CollectionReference dataCollection;
  DatabaseService({this.uid, this.dataCollection});
}