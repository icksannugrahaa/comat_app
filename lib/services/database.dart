import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comat_apps/models/event.dart';
import 'package:comat_apps/models/user_detail.dart';

class DatabaseService {
  
  final String uid;
  DatabaseService({this.uid});
  
  final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");
  final CollectionReference eventCollection = FirebaseFirestore.instance.collection("events");

  Future updateUser(String name, String email, String avatar, String phone) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'email': email,
      'avatar': avatar,
      'phone': phone
    });
  }

  UserDetail _userDetailFromSnapshot(DocumentSnapshot snapshot) {
    return UserDetail(
      uid: uid,
      name: snapshot.get('name') ?? '',
      avatar: snapshot.get('avatar') ?? '',
      email: snapshot.get('email') ?? '',
      phone: snapshot.get('phone') ?? ''
    );
  }

  List<UserDetail> _userListFromSnapshot(QuerySnapshot qs) {
    return qs.docs.map((doc){
      return UserDetail(
        name: doc.get('name') ?? '',
        avatar: doc.get('avatar') ?? '',
        phone: doc.get('phone') ?? '',
        email: doc.get('email') ?? ''
      );
    }).toList();
  }

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

  Stream<List<UserDetail>> get users {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }

  Stream<List<Event>> get events {
    return eventCollection.snapshots().map(_eventListFromSnapshot);
  }

  Stream<UserDetail> get userData {
    return userCollection.doc(uid).snapshots().map(_userDetailFromSnapshot);
  }
}