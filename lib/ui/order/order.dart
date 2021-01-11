import 'package:comat_apps/databases/db_order.dart';
import 'package:comat_apps/models/event.dart';
import 'package:comat_apps/models/order.dart';
import 'package:comat_apps/models/user.dart';
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
      value: DatabaseServiceOrders().myOrder('eid', 'isEqualTo', args.event.eid, user.uid),
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

  @override
  Widget build(BuildContext context) {
    final myOrder = Provider.of<List<Order>>(context);
    return Positioned(
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
              if(myOrder != null) {
                myToast("Anda telah melakukan order pada event ini sebelumnya, silahkan pilih event lain !", Colors.red);
                Navigator.pushReplacementNamed(context, '/event-search');
              } else {
                Map<String, dynamic> _order = {
                  "uid": user.uid,
                  "eid": args.event.eid,
                  "orderDate": DateTime.now(),
                  "paymentDate": null, 
                  "paymentMethod": _paymentMethod,
                  "paymentTotal": args.event.price,
                  "status": "Menunggu pembayaran",
                };
                await DatabaseServiceOrders().orderCreate(_order);
                myToast("Pemesanan tiket berhasil, silahkan bayar sesuai metode pembayaran !", Colors.green[400]);
                Navigator.pushReplacementNamed(context, '/home');
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