// System
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:indonesia/indonesia.dart';
import 'package:provider/provider.dart';

// My Package
import 'package:comat_apps/models/event.dart';
import 'package:comat_apps/ui/event/event_argument.dart';
import 'package:comat_apps/ui/constant.dart';
import 'package:comat_apps/ui/helpers/ui_helper.dart';
import 'package:comat_apps/ui/custom_widget/my_toast.dart';
import 'package:comat_apps/helpers/my_helpers.dart';
import 'package:comat_apps/databases/db_event_committee.dart';
import 'package:comat_apps/models/event_committee.dart';
import 'package:comat_apps/models/user.dart';

class EventDetail extends StatefulWidget {
  final Event event;
  static const routeName = '/event-detail';

  EventDetail({Key key, this.event}) : super(key: key);

  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {

  final MyHelpers _helpers = MyHelpers();
  
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final EventArguments args = ModalRoute.of(context).settings.arguments;
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(args.event.timeStart.substring(18, 28)) * 1000);
    final dateStart = DateTime.fromMillisecondsSinceEpoch(int.parse(args.event.timeStart.substring(18, 28)) * 1000);
    final dateEnd = DateTime.fromMillisecondsSinceEpoch(int.parse(args.event.timeEnd.substring(18, 28)) * 1000);
    final date2 = DateTime.now();
    final difference = date.difference(date2).inDays;
    // final percentace = (args.event.remains * 100) / args.event.limit;
    final timestart = DateFormat('Hms').format(dateStart);
    final timeend = DateFormat('Hms').format(dateEnd);
    final String tanggal = DateFormat('dd').format(date);
    final String bulan = DateFormat('MM').format(date);
    final String hari = DateFormat('EEEE').format(date);
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: StreamProvider<List<EventCommittee>>.value(
        value: DatabaseServiceEventCommittee().myEventsCommitee('committeeCode',args.event.committeeCode,user.uid),
        child: SingleChildScrollView(
          child: Container(
            width: width,
            child: Stack(
              children: [
                Container(
                  height: height*0.55,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        args.event.image
                      ),
                      fit: BoxFit.fill
                    )
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.9),
                          Colors.black.withOpacity(0.6),
                          Colors.black.withOpacity(0.0),
                          Colors.black.withOpacity(0.0),
                          Colors.black.withOpacity(0.4),
                          Colors.black.withOpacity(0.9),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight
                      )
                    ),
                  ),
                ),
                Container(
                  width: width, 
                  margin: EdgeInsets.only(top: height*0.5),
                  padding: EdgeInsets.all(30),
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
                      Text(
                        args.event.title,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                        ),
                      ),
                      SizedBox(height: 25),
                      Container(
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: primaryLight, //ganti
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(_helpers.toIndoMonth(bulan, false),
                                      style: monthStyle),
                                  Text(tanggal,
                                      style: titleStyle),
                                ],
                              ),
                            ),
                            UIHelper.horizontalSpace(12),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(_helpers.toIndoDay(hari),
                                    style: titleStyle),
                                UIHelper.verticalSpace(4),
                                Text("$timestart - $timeend", style: subtitleStyle),
                              ],
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                      SizedBox(height: 25),
                      Text(
                        "Detail event :",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w900
                        ),
                      ),
                      SizedBox(height: 8,),
                      Text(
                        args.event.description,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          letterSpacing: 0.5,
                          wordSpacing: 1.5,
                          fontWeight: FontWeight.normal
                        ),
                      ),
                      SizedBox(height: 25),
                      Text(
                        "Rundown :",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w900
                        ),
                      ),
                      SizedBox(height: 8,),
                      Text(
                        args.event.rundown,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          letterSpacing: 0.5,
                          wordSpacing: 1.5,
                          fontWeight: FontWeight.normal
                        ),
                      ),
                      SizedBox(height: 25),
                      Text(
                        "Banefit :",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w900
                        ),
                      ),
                      SizedBox(height: 8,),
                      Text(
                        args.event.obtained,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          letterSpacing: 0.5,
                          wordSpacing: 1.5,
                          fontWeight: FontWeight.normal
                        ),
                      ),
                      SizedBox(height: 25),
                      Text(
                        "Alamat :",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w900
                        ),
                      ),
                      SizedBox(height: 8,),
                      Text(
                        args.event.place,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          letterSpacing: 0.5,
                          wordSpacing: 1.5,
                          fontWeight: FontWeight.normal
                        ),
                      ),
                      SizedBox(height: 25),
                      Text(
                        "Kuota pendaftaran :",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w900
                        ),
                      ),
                      SizedBox(height: 8,),
                      Text(
                        "${args.event.limit} dari ${args.event.remains}",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          letterSpacing: 0.5,
                          wordSpacing: 1.5,
                          fontWeight: FontWeight.normal
                        ),
                      ),
                      SizedBox(height: 40,),
                      BuildButtonBuy(args: args, difference: difference, user: user)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 45, left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          child: Material(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.transparent,
                            child: IconButton(
                              splashRadius: 50,
                              icon: Icon(Icons.keyboard_backspace, color: Colors.white,),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          child: Material(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.transparent,
                            child: IconButton(
                              splashRadius: 50,
                              icon: Icon(Icons.share, color: Colors.white,),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),  
          )
        ),
      ),
    );
  }

}

class BuildButtonBuy extends StatelessWidget {
  const BuildButtonBuy({
    Key key,
    @required this.args,
    @required this.difference,
    @required this.user,
  }) : super(key: key);

  final EventArguments args;
  final int difference;
  final User user;

  @override
  Widget build(BuildContext context) {
    final eventCommittee = Provider.of<List<EventCommittee>>(context);
    if(eventCommittee != null) {
      eventCommittee.forEach((element) {
        print("user yang tersedia : ${element.userId}");
      });
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Harga :",
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 13,
                fontWeight: FontWeight.w600
              ),
            ),
            Text(
              (args.event.price == 0 ? "Gratis" : rupiah(args.event.price, separator: ',', trailing: '.00')),
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
            )
          ],
        ),
        RaisedButton(
          onPressed: () {
            if(args.event.status == true && !(difference < 1)) {
              if(user != null) {
                if(!eventCommittee.isEmpty) {
                  myToast("Anda tidak dapat mengikuti event yang anda buat !", Colors.green[400]);
                } else {
                  myToast("Aplikasi sedang tahap pengembangan", Colors.green[400]);
                }
              } else {
                myToast("Silahkan login terlebih dahulu !", Colors.red);
              }
            } else {
              myToast("Event sudah tidak tersedia", Colors.red);
            }
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          color: args.event.status == true && !(difference < 1) ? Colors.green[400] : Colors.red,
          padding: EdgeInsets.all(15),
          child: Text(
            args.event.status == true && !(difference < 1) ? "Daftar" : "Tidak tersedia",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14
            ),
          ),    
        )
      ],
    );
  }
}
