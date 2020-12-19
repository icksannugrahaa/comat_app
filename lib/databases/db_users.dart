import 'package:comat_apps/models/user_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comat_apps/databases/database.dart';

class DatabaseServiceUsers extends DatabaseService {
  
  DatabaseServiceUsers({uid, dataCollection}) : super(uid: uid, dataCollection: FirebaseFirestore.instance.collection("users"));
    
  // final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");

  Future updateUser(String name, String email, String avatar, String phone, bool gSignIn) async {
    return await dataCollection.doc(uid).set({
      'name': name,
      'email': email,
      'avatar': avatar,
      'phone': phone,
      'gSignIn': gSignIn
    });
  }

  UserDetail _userDetailFromSnapshot(DocumentSnapshot snapshot) {
    return UserDetail(
      uid: uid,
      name: snapshot.get('name') ?? '',
      avatar: snapshot.get('avatar') ?? '',
      email: snapshot.get('email') ?? '',
      phone: snapshot.get('phone') ?? '',
      gSignIn: snapshot.get('gSignIn') ?? false
    );
  }

  List<UserDetail> _userListFromSnapshot(QuerySnapshot qs) {
    return qs.docs.map((doc){
      return UserDetail(
        uid: doc.reference.id,
        name: doc.get('name') ?? '',
        avatar: doc.get('avatar') ?? '',
        phone: doc.get('phone') ?? '',
        email: doc.get('email') ?? '',
        gSignIn: doc.get('gSignIn') ?? false
      );
    }).toList();
  }

  Stream<List<UserDetail>> get users {
    return dataCollection.snapshots().map(_userListFromSnapshot);
  }

  Stream<UserDetail> get userData {
    return dataCollection.doc(uid).snapshots().map(_userDetailFromSnapshot);
  }
}