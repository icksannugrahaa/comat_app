class Order {
  final String oid;
  final String uid;
  final String eid;
  final String paymentMethod;
  final String paymentTotal;
  final String paymentDate;
  final String orderDate;
  final String status;
  Order({this.orderDate, this.eid, this.oid, this.paymentDate, this.paymentMethod, this.paymentTotal, this.status, this.uid});
}