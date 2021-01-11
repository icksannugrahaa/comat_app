import 'package:cloud_firestore/cloud_firestore.dart';
class DatabaseService {
  final String id;
  final CollectionReference dataCollection;
  DatabaseService({this.id, this.dataCollection});
}