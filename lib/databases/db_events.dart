import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comat_apps/databases/database.dart';
import 'package:comat_apps/models/event.dart';

class DatabaseServiceEvents extends DatabaseService {
  DatabaseServiceEvents({uid, dataCollection}) : super(uid: uid, dataCollection: FirebaseFirestore.instance.collection("events"));

  List<Event> _eventListFromSnapshot(QuerySnapshot qs) {
    return qs.docs.map((doc){
      return Event(
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
      );
    }).toList();
  }
  
  Stream<List<Event>> get events {
    return dataCollection.snapshots().map(_eventListFromSnapshot);
  }
}