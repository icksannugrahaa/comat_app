import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comat_apps/databases/database.dart';
import 'package:comat_apps/models/event_committee.dart';

class DatabaseServiceEventCommittee extends DatabaseService {
  DatabaseServiceEventCommittee ({ecid, dataCollection}) : super(id: ecid, dataCollection: FirebaseFirestore.instance.collection("event_committee"));

  eventCommitteeCreate(Map<String, dynamic> data) {
    dataCollection.add(data);
  }
  eventCommitteeDelete(dynamic ecid) async {
    QuerySnapshot querySnapshot = await dataCollection.where('committeeCode', isEqualTo: ecid).get();
    querySnapshot.docs.forEach((element) { 
      element.reference.delete();
    });
  }
  List<EventCommittee> _eventCommiteeListFromSnapshot(QuerySnapshot qs) {
    return qs.docs.map((doc){
      return EventCommittee(
        collectionId: doc.reference.id,
        userData: doc.get('userData') ?? '',
        committeeCode: doc.get('committeeCode') ?? '',
        level: doc.get('level') ?? '',
      );
    }).toList();
  }
  Stream<List<EventCommittee>> myEventsCommitee(String key,dynamic value, String ecid) { 
    if(key != null && value != null) {
      return dataCollection
        .where(key, isEqualTo: value)
        .orderBy('userData', descending: false)
        .snapshots()
        .map(_eventCommiteeListFromSnapshot);
    } else {
      return dataCollection
        .orderBy('userData', descending: false)
        .snapshots()
        .map(_eventCommiteeListFromSnapshot);
    } 
  }
  Stream<List<EventCommittee>> myEvent(String ecid) {
    return dataCollection
      .where('userData', arrayContains: ecid)
      .snapshots()
      .map(_eventCommiteeListFromSnapshot);
  }
  Stream<List<EventCommittee>> allEvent() {
    return dataCollection
      .orderBy('userData', descending: false)
      .snapshots()
      .map(_eventCommiteeListFromSnapshot);
  }
}