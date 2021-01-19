import 'package:comat_apps/databases/db_order.dart';
import 'package:comat_apps/databases/db_users.dart';
import 'package:comat_apps/models/user_detail.dart';
import 'package:comat_apps/models/event.dart';
import 'package:comat_apps/models/order.dart';
import 'package:comat_apps/models/user.dart';
import 'package:comat_apps/ui/custom_widget/my_alert_dialog.dart';
import 'package:comat_apps/ui/custom_widget/my_appbar.dart';
import 'package:comat_apps/ui/custom_widget/my_toast.dart';
import 'package:comat_apps/ui/order/order_argument.dart';
import 'package:flutter/material.dart';
import 'package:indonesia/indonesia.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatefulWidget {
  final Event event;
  static const routeName = '/payment';

  OrderPage({Key key, this.event}) : super(key: key);
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {

  String _paymentMethod = 'Bayar Di Tempat';
  bool _isRadioSelected = false;

  void _showPaymentMethod(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30)
              )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30, top: 25),
                  child: Text(
                    "Pilih Metode Pembayaran",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                    ),
                  ),
                ),
                LinkedLabelRadio(
                  label: 'Bayar Di Tempat',
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  value: true,
                  imgUrl: 'https://www.kredivo.id/offline/images/icon-store.png',
                  groupValue: _isRadioSelected,
                  onChanged: (bool newValue) {
                    setState(() {
                      _isRadioSelected = newValue;
                      _paymentMethod = "Bayar Di Tempat";
                    });
                    Navigator.pop(context);
                  },
                ),
                LinkedLabelRadio(
                  label: 'Pembayaran lain',
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  value: false,
                  groupValue: _isRadioSelected,
                  onChanged: (bool newValue) {
                    setState(() {
                      _isRadioSelected = newValue;
                      _paymentMethod = "Tidak tersedia";
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          )
        );
      }
    );
  }

  void _showOrderDetail(context, e) {

    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30)
              )
            ),
            child: ListView(
              padding: const EdgeInsets.only(left: 30, top: 25),
              children: [
                Text(
                  "Detail Pembayaran",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                  ),
                ),
                ListTile(
                  title: Text(e.title),
                  subtitle: Text(e.organizer),
                  trailing: Text(e.price == 0 ? "Gratis" : rupiah(e.price, separator: ',', trailing: '.00')),
                )
              ],
            )
          )
        );
      }
    );
  }
  @override
  Widget build(BuildContext context) {
    final OrderArguments args = ModalRoute.of(context).settings.arguments;
    final double height = MediaQuery.of(context).size.height;
    final user = Provider.of<User>(context);

    return StreamProvider<List<Order>>.value(
      value: DatabaseServiceOrders().myOrder('', '', '', user.uid),
      child: Scaffold(
        appBar: MyAppBar(isSearchAble: false,),
        body: Container(
          height: height,
          child: Stack(
            children: [
              ListView(
                padding: EdgeInsets.all(20),
                children: [
                  Text(
                    "Pembayaran",
                    style: TextStyle(
                      fontSize: 25, fontWeight: FontWeight.w500
                    ),
                  ),
                  SizedBox(height: 15,),
                  ListTile(
                    title: Text('Total Tagihan', 
                      style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500
                      ),
                    ),
                    subtitle: Text(args.event.price == 0 ? "Gratis" : rupiah(args.event.price, separator: ',', trailing: '.00'),
                      style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500
                      ),
                    ),
                    trailing: InkWell(
                      onTap: () => _showOrderDetail(context, args.event),
                      child: Text("Detail", 
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blue[400],
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  ListTile(
                    title: Text('Metode Pembayaran'),
                    subtitle: Text(_paymentMethod),
                    trailing: InkWell(
                      onTap: () => _showPaymentMethod(context),
                      child: Text("Lihat semua",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blue[400],
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              BuildBuyButton(args: args, paymentMethod: _paymentMethod, user: user),
            ],
          ),
        ),
      ),
    );
  }
}

class BuildBuyButton extends StatelessWidget {
  const BuildBuyButton({
    Key key,
    @required this.args,
    @required String paymentMethod,
    @required this.user,
  }) : _paymentMethod = paymentMethod, super(key: key);

  final OrderArguments args;
  final String _paymentMethod;
  final User user;

  _func(UserDetail users, bool isTrue) async {
    if(isTrue) {
        List<dynamic> _user = [
          users.uid,
          users.name,
          users.email,
          users.avatar,
          users.phone.toString(),
        ];

        List<dynamic> _event = [
          args.event.eid,
          args.event.description, 
          args.event.image,
          args.event.limit,
          args.event.obtained,
          args.event.organizer,
          args.event.place,
          args.event.price,
          args.event.remains,
          args.event.status,
          DateTime.fromMillisecondsSinceEpoch(int.parse(args.event.timeEnd.substring(18, 28)) * 1000),
          DateTime.fromMillisecondsSinceEpoch(int.parse(args.event.timeStart.substring(18, 28)) * 1000),
          args.event.title,
          args.event.category,
        ];

        Map<String, dynamic> _order = {
          "userData": _user,
          "eventData": _event,
          "orderDate": DateTime.now(),
          "paymentDate": null, 
          "paymentMethod": _paymentMethod,
          "paymentTotal": args.event.price,
          "status": "Menunggu pembayaran",
        };
        await DatabaseServiceOrders().orderCreate(_order);
    }
  }

  @override
  Widget build(BuildContext context) {
    final myOrder = Provider.of<List<Order>>(context);
    return StreamBuilder<UserDetail>(
      stream: DatabaseServiceUsers(uid: user.uid).userData,
      builder: (context, snapshot) {
        UserDetail userDetail = snapshot.data;
        // print(userDetail != null ? userDetail.name : userDetail!=null);
        return userDetail == null ? Center(child: CircularProgressIndicator()) : Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ListTile(
            title: Text('Total Tagihan'),
            subtitle: Text(args.event.price == 0 ? "Gratis" : rupiah(args.event.price, separator: ',', trailing: '.00'),
              style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w500
              ),
            ),
            trailing: RaisedButton(
              onPressed: () async {
                if(_paymentMethod.contains("Tidak tersedia")) {
                  myToast("Tolong ganti metode pembayaran !", Colors.red);
                } else {
                  if(myOrder.length > 0) {
                    myOrder.forEach((element) {
                      final eventDate = DateTime.fromMillisecondsSinceEpoch(int.parse(args.event.timeStart.toString().substring(18, 28)) * 1000);
                      final orderEventDate = DateTime.fromMillisecondsSinceEpoch(int.parse(element.eventData.elementAt(11).toString().substring(18, 28)) * 1000);
                      
                      if(element.eventData.contains(args.event.eid)) {
                        myToast("Anda telah melakukan order pada event ini sebelumnya, silahkan pilih event lain !", Colors.red);
                        Navigator.pop(context);
                        return true;
                      } else if(eventDate.isAtSameMomentAs(orderEventDate)) {
                        myToast("Anda tidak bisa mengikuti event\n Karena anda telah mengikuti event '${element.eventData.elementAt(12)}' dengan jadwal yang sama\n Silahkan pilih event lain !", Colors.red);
                        Navigator.pop(context);
                        return true;
                      } else {
                        myAlertDialog(context, "Pastikan tidak ada event dengan jadwal yang sama !\nTekan ""Lanjutkan"" untuk menyetujui.",userDetail,_func,"Pemesanan tiket berhasil, silahkan bayar sesuai metode pembayaran !", Colors.green, '/home');
                      }
                    });
                  } else {
                    myAlertDialog(context,"Apakah anda yakin akan mendaftar di Event ini ?\nTekan 'Lanjutkan' untuk menyetujui.",userDetail,_func,"Pemesanan tiket berhasil, silahkan bayar sesuai metode pembayaran !", Colors.green, '/home');
                  }
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              color: !_paymentMethod.contains("Tidak tersedia") ? Colors.green[400] : Colors.red,
              padding: EdgeInsets.all(15),
              child: Text("Bayar",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14
                ),
              ),    
            ),
          ),
        );
      }
    );
  }
}

class LinkedLabelRadio extends StatelessWidget {
  const LinkedLabelRadio({
    this.label,
    this.padding,
    this.groupValue,
    this.value,
    this.onChanged,
    this.imgUrl
  });

  final String label;
  final EdgeInsets padding;
  final bool groupValue;
  final bool value;
  final Function onChanged;
  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: ListTile(
        title: Text(label),
        leading: imgUrl != null 
          ? Image.network(imgUrl, width: 40, height: 40,) 
          : Icon(Icons.error_outline, size: 40,),
        trailing: Radio<bool>(
          groupValue: groupValue,
          value: value,
          onChanged: (bool newValue) {
            onChanged(newValue);
          }),
      ),
    );
  }
}