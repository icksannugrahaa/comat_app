import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comat_apps/databases/database.dart';
import 'package:comat_apps/models/order.dart';

class DatabaseServiceOrders extends DatabaseService {
  DatabaseServiceOrders({oid, dataCollection}) : super(id: oid, dataCollection: FirebaseFirestore.instance.collection("orders"));

  orderCreate(Map<String, dynamic> data) {
    dataCollection.add(data);
  }

  orderDelete(dynamic oid) async {
    dataCollection.doc(oid).delete();
  }

  orderUpdate(dynamic oid, Map<String, dynamic> data) async {
    dataCollection.doc(oid).update(data);
  }

  List<Order> _orderListFromSnapshot(QuerySnapshot qs) {
    return qs.docs.map((doc){
      return Order(
        oid: doc.reference.id,
        eid: doc.get('eid') ?? '',
        uid: doc.get('uid') ?? '',
        orderDate: doc.get('orderDate').toString() ?? '',
        paymentDate: doc.get('paymentDate').toString() ?? '',
        paymentMethod: doc.get('paymentMethod') ?? '',
        paymentTotal: doc.get('paymentTotal').toString() ?? '',
        status: doc.get('status') ?? '',
      );
    }).toList();
  }

  Stream<List<Order>> myOrder(String key,String where,dynamic value, String uid) { 
    if(key != null && where != null && value != null) {
      if(where == 'isEqualTo') {
        return dataCollection
          .where(key, isEqualTo: value)
          .where('uid', isEqualTo: uid)
          .orderBy('orderDate', descending: false)
          .limit(10)
          .snapshots()
          .map(_orderListFromSnapshot);
      } else if(where == 'isGreaterThan') {
        return dataCollection
          .where(key, isGreaterThan: value)
          .where('uid', isEqualTo: uid)
          .orderBy('orderDate', descending: false)
          .limit(10)
          .snapshots()
          .map(_orderListFromSnapshot);
      } else if(where == 'isLessThan') {
        return dataCollection
          .where(key, isLessThan: value)
          .where('uid', isEqualTo: uid)
          .orderBy('orderDate', descending: false)
          .limit(10)
          .snapshots()
          .map(_orderListFromSnapshot);
      } else if(where == 'isNull') {
        return dataCollection
          .where(key, isNull: value)
          .where('uid', isEqualTo: uid)
          .orderBy('orderDate', descending: false)
          .limit(10)
          .snapshots()
          .map(_orderListFromSnapshot);
      } else if(where == 'isLike') {
        // List<dynamic> val = value; 
        return dataCollection
          .where(key, arrayContains: value)
          .where('uid', isEqualTo: uid)
          .orderBy('orderDate', descending: false)
          .limit(10)
          .snapshots()
          .map(_orderListFromSnapshot);
      } else {
        return dataCollection
          .orderBy('orderDate', descending: false)
          .where('uid', isEqualTo: uid)
          .limit(10)
          .snapshots()
          .map(_orderListFromSnapshot);
      }
      
    } else {
      return dataCollection.orderBy('orderDate', descending: false).snapshots().map(_orderListFromSnapshot);
    }
  }
  
  Stream<List<Order>> orders(String key,String where,dynamic value, String eid) { 
    if(key != null && where != null && value != null) {
      if(where == 'isEqualTo') {
        return dataCollection
          .where(key, isEqualTo: value)
          .where('eid', isEqualTo: eid)
          .orderBy('orderDate', descending: false)
          .limit(10)
          .snapshots()
          .map(_orderListFromSnapshot);
      } else if(where == 'isGreaterThan') {
        return dataCollection
          .where(key, isGreaterThan: value)
          .where('eid', isEqualTo: eid)
          .orderBy('orderDate', descending: false)
          .limit(10)
          .snapshots()
          .map(_orderListFromSnapshot);
      } else if(where == 'isLessThan') {
        return dataCollection
          .where(key, isLessThan: value)
          .where('eid', isEqualTo: eid)
          .orderBy('orderDate', descending: false)
          .limit(10)
          .snapshots()
          .map(_orderListFromSnapshot);
      } else if(where == 'isNull') {
        return dataCollection
          .where(key, isNull: value)
          .where('eid', isEqualTo: eid)
          .orderBy('orderDate', descending: false)
          .limit(10)
          .snapshots()
          .map(_orderListFromSnapshot);
      } else if(where == 'isLike') {
        // List<dynamic> val = value; 
        return dataCollection
          .where(key, arrayContains: value)
          .where('eid', isEqualTo: eid)
          .orderBy('orderDate', descending: false)
          .limit(10)
          .snapshots()
          .map(_orderListFromSnapshot);
      } else {
        return dataCollection
          .orderBy('orderDate', descending: false)
          .where('eid', isEqualTo: eid)
          .limit(10)
          .snapshots()
          .map(_orderListFromSnapshot);
      }
      
    } else {
      return dataCollection.orderBy('orderDate', descending: false).snapshots().map(_orderListFromSnapshot);
    }
  }
}