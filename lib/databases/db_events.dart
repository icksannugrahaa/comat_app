import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comat_apps/databases/database.dart';
import 'package:comat_apps/models/event.dart';

class DatabaseServiceEvents extends DatabaseService {
  DatabaseServiceEvents({eid, dataCollection}) : super(id: eid, dataCollection: FirebaseFirestore.instance.collection("events"));

  eventCreate(Map<String, dynamic> data) {
    dataCollection.add(data);
  }

  eventDelete(dynamic eid) async {
    dataCollection.doc(eid).delete();
  }

  eventUpdate(dynamic eid, Map<String, dynamic> data) async {
    dataCollection.doc(eid).update(data);
  }

  List<Event> _eventListFromSnapshot(QuerySnapshot qs) {
    return qs.docs.map((doc){
      return Event(
        eid: doc.reference.id,
        userCreated: doc.get('userCreated') ?? '',
        committeeCode: doc.get('committeeCode') ?? '',
        title: doc.get('title') ?? '',
        description: doc.get('description') ?? '',
        place: doc.get('place') ?? '',
        date: doc.get('date').toString() ?? '',
        timeStart: doc.get('time_start').toString() ?? '',
        timeEnd: doc.get('time_end').toString() ?? '',
        image: doc.get('image') ?? '',
        limit: doc.get('limit') ?? 0,
        remains: doc.get('remains') ?? 0,
        status: doc.get('status') ?? false,
        category: doc.get('category') ?? '',
        obtained: doc.get('obtained') ?? '',
        organizer: doc.get('organizer') ?? '',
        price: doc.get('price') ?? 0,
        rundown: doc.get('rundown') ?? '',
        shareUrl: doc.get('share_url') ?? '',
        committee: doc.get('committee') ?? '',
      );
    }).toList();
  }

  Stream<List<Event>> myEvents(String key,String where,dynamic value, String uid) { 
    if(key != null && where != null && value != null) {
      if(where == 'isEqualTo') {
        return dataCollection
          .where(key, isEqualTo: value)
          .where('userCreated', isEqualTo: uid)
          .orderBy('date', descending: false)
          .limit(10)
          .snapshots()
          .map(_eventListFromSnapshot);
      } else if(where == 'isGreaterThan') {
        return dataCollection
          .where(key, isGreaterThan: value)
          .where('userCreated', isEqualTo: uid)
          .orderBy('date', descending: false)
          .limit(10)
          .snapshots()
          .map(_eventListFromSnapshot);
      } else if(where == 'isLessThan') {
        return dataCollection
          .where(key, isLessThan: value)
          .where('userCreated', isEqualTo: uid)
          .orderBy('date', descending: false)
          .limit(10)
          .snapshots()
          .map(_eventListFromSnapshot);
      } else if(where == 'isNull') {
        return dataCollection
          .where(key, isNull: value)
          .where('userCreated', isEqualTo: uid)
          .orderBy('date', descending: false)
          .limit(10)
          .snapshots()
          .map(_eventListFromSnapshot);
      } else if(where == 'isLike') {
        // List<dynamic> val = value; 
        return dataCollection
          .where(key, arrayContains: value)
          .where('userCreated', isEqualTo: uid)
          .orderBy('date', descending: false)
          .limit(10)
          .snapshots()
          .map(_eventListFromSnapshot);
      } else {
        return dataCollection
          .orderBy('date', descending: false)
          .where('userCreated', isEqualTo: uid)
          .limit(10)
          .snapshots()
          .map(_eventListFromSnapshot);
      }
      
    } else {
      return dataCollection.orderBy('date', descending: false).snapshots().map(_eventListFromSnapshot);
    }
  }
  
  Stream<List<Event>> events(String key,String where,dynamic value) { 
    if(key != null && where != null && value != null) {
      if(where == 'isEqualTo') {
        return dataCollection
          .where(key, isEqualTo: value)
          .orderBy('date', descending: false)
          .limit(10)
          .snapshots()
          .map(_eventListFromSnapshot);
      } else if(where == 'isGreaterThan') {
        return dataCollection
          .where(key, isGreaterThan: value)
          .orderBy('date', descending: false)
          .limit(10)
          .snapshots()
          .map(_eventListFromSnapshot);
      } else if(where == 'isLessThan') {
        return dataCollection
          .where(key, isLessThan: value)
          .orderBy('date', descending: false)
          .limit(10)
          .snapshots()
          .map(_eventListFromSnapshot);
      } else if(where == 'isNull') {
        return dataCollection
          .where(key, isNull: value)
          .orderBy('date', descending: false)
          .limit(10)
          .snapshots()
          .map(_eventListFromSnapshot);
      } else if(where == 'isLike') {
        List<dynamic> val = List<dynamic>();
        val.add(value);
        return dataCollection
          .where(key, arrayContainsAny: val)
          .orderBy('date', descending: false)
          .limit(10)
          .snapshots()
          .map(_eventListFromSnapshot);
      } else {
        return dataCollection
          .orderBy('date', descending: false)
          .limit(10)
          .snapshots()
          .map(_eventListFromSnapshot);
      }
    } else {
      return dataCollection.orderBy('date', descending: false).snapshots().map(_eventListFromSnapshot);
    }
  }
}