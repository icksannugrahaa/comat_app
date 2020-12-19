import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comat_apps/databases/database.dart';

class DatabaseServiceEventCommittee extends DatabaseService {
  DatabaseServiceEventCommittee ({uid, dataCollection}) : super(uid: uid, dataCollection: FirebaseFirestore.instance.collection("event_committee"));

  eventCommitteeCreate(Map<String, dynamic> data) {
    dataCollection.add(data);
  }
}