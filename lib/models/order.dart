class Order {
  final String oid;
  final List<dynamic> userData;
  final List<dynamic> eventData;
  final String paymentMethod;
  final String paymentTotal;
  final String paymentDate;
  final String orderDate;
  final String status;
  Order({this.orderDate, this.eventData, this.oid, this.paymentDate, this.paymentMethod, this.paymentTotal, this.status, this.userData});
}