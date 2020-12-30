import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comat_apps/databases/database.dart';
import 'package:comat_apps/models/event_committee.dart';

class DatabaseServiceEventCommittee extends DatabaseService {
  DatabaseServiceEventCommittee ({uid, dataCollection}) : super(uid: uid, dataCollection: FirebaseFirestore.instance.collection("event_committee"));

  eventCommitteeCreate(Map<String, dynamic> data) {
    dataCollection.add(data);
  }
  eventCommitteeDelete(dynamic eid) async {
    QuerySnapshot querySnapshot = await dataCollection.where('committeeCode', isEqualTo: eid).get();
    querySnapshot.docs.forEach((element) { 
      element.reference.delete();
    });
  }
  List<EventCommittee> _eventCommiteeListFromSnapshot(QuerySnapshot qs) {
    return qs.docs.map((doc){
      return EventCommittee(
        collectionId: doc.reference.id,
        userId: doc.get('userId') ?? '',
        committeeCode: doc.get('committeeCode') ?? '',
        level: doc.get('level') ?? '',
      );
    }).toList();
  }
  Stream<List<EventCommittee>> myEventsCommitee(String key,dynamic value, String uid) { 
    return dataCollection
      .where(key, isEqualTo: value)
      .where('userId', isEqualTo: uid)
      .snapshots()
      .map(_eventCommiteeListFromSnapshot); 
  }
}