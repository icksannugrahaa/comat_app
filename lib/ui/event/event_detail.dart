// System
import 'dart:io';
import 'package:comat_apps/ui/order/order.dart';
import 'package:comat_apps/ui/order/order_argument.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:indonesia/indonesia.dart';
import 'package:provider/provider.dart';
import 'package:social_share/social_share.dart';
import 'package:screenshot/screenshot.dart';

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
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
  }
  
  void _showSocialMediaShare(context, e, date) {
    final String tanggal = DateFormat('dd').format(date);
    final String bulan = DateFormat('MM').format(date);
    String hari = DateFormat('EEEE').format(date);
    final String tahun = DateFormat('yyyy').format(date);
    hari = _helpers.toIndoDay(hari);
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
                    "Bagikan melalui",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                    ),
                  ),
                ),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  children: [
                    Center(
                      child: FlatButton(
                        onPressed: () async {
                          await screenshotController.capture().then((image) async {
                            //facebook appId is mandatory for andorid or else share won't work
                            Platform.isAndroid
                            ? SocialShare.shareFacebookStory(image.path,
                                    "#ffffff", "#000000", e.shareUrl,
                                    appId: "368834474541379")
                                .then((data) {
                                print(data);
                              })
                            : SocialShare.shareFacebookStory(image.path,
                                    "#ffffff", "#000000", e.shareUrl)
                                .then((data) {
                                print(data);
                              });
                          });
                        },
                        padding: EdgeInsets.all(0.0),
                        child: Image.asset('assets/icons/ic_facebook.png', width: 50, height: 50,)
                      ),
                    ),
                    Center(
                      child: FlatButton(
                        onPressed: () async {
                          SocialShare.shareWhatsapp(
                                  "Event ${e.title} \nDiselengarakan oleh ${e.organizer} \nSegera install aplikasi dan daftarkan diri anda sebelum $hari, $tanggal-$bulan-$tahun\n\nLink pendaftaran : ${e.shareUrl}",)
                              .then((data) {
                            print(data);
                          });
                        },
                        padding: EdgeInsets.all(0.0),
                        child: Image.asset('assets/icons/ic_whatsapp.png', width: 50, height: 50,)
                      ),
                    ),
                    Center(
                      child: FlatButton(
                        onPressed: () async {
                          await screenshotController.capture().then((image) async {
                            SocialShare.shareInstagramStory(image.path,
                                    "#ffffff", "#000000", widget.event.shareUrl)
                                .then((data) {
                              print(data);
                            });
                          });
                        },
                        padding: EdgeInsets.all(0.0),
                        child: Image.asset('assets/icons/ic_instagram.jpg', width: 50, height: 50,)
                      ),
                    ),
                    Center(
                      child: FlatButton(
                        onPressed: () async {
                          SocialShare.shareTelegram(
                                  "Event ${e.title} \nDiselengarakan oleh ${e.organizer} \nSegera install aplikasi dan daftarkan diri anda sebelum $hari, $tanggal-$bulan-$tahun\n\nLink pendaftaran : ${e.shareUrl}")
                              .then((data) {
                            print(data);
                          });
                        },
                        padding: EdgeInsets.all(0.0),
                        child: Image.asset('assets/icons/ic_telegram.png', width: 50, height: 50,)
                      ),
                    ),
                    Center(
                      child: FlatButton(
                        onPressed: () async {
                          SocialShare.shareTwitter(
                                  "Event ${e.title} \nDiselengarakan oleh ${e.organizer} \nSegera install aplikasi dan daftarkan diri anda sebelum $hari, $tanggal-$bulan-$tahun\n\nLink pendaftaran : ${e.shareUrl}",
                                  hashtags: e.keywords,
                                  url: e.shareUrl,
                                  trailingText: "\nhello")
                              .then((data) {
                            print(data);
                          });
                        },
                        padding: EdgeInsets.all(0.0),
                        child: Image.asset('assets/icons/ic_twitter.png', width: 50, height: 50,)
                      ),
                    ),
                    Center(
                      child: IconButton(
                        onPressed: () async {
                          SocialShare.copyToClipboard(
                            "Event ${e.title} \nDiselengarakan oleh ${e.organizer} \nSegera install aplikasi dan daftarkan diri anda sebelum $hari, $tanggal-$bulan-$tahun\n\nLink pendaftaran : ${e.shareUrl}",
                          ).then((data) {
                            print(data);
                          });
                          myToast("Disalin kedalam clipboard", Colors.green[400]);
                          Navigator.pop(context);
                        },
                        padding: EdgeInsets.all(0.0),
                        icon: Icon(Icons.content_copy),
                        iconSize: 30,
                      ),
                    ),
                  ],
                ),
              ],
            )
          )
        );
      }
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final EventArguments args = ModalRoute.of(context).settings.arguments;
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(args.event.timeStart.substring(18, 28)) * 1000);
    final dateStart = DateTime.fromMillisecondsSinceEpoch(int.parse(args.event.timeStart.substring(18, 28)) * 1000);
    final dateEnd = DateTime.fromMillisecondsSinceEpoch(int.parse(args.event.timeEnd.substring(18, 28)) * 1000);
    final date2 = DateTime.now();
    final difference = date.difference(date2).inMinutes;
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
        value: DatabaseServiceEventCommittee().myEventsCommitee('committeeCode',args.event.committeeCode,user != null ? user.uid : null),
        child: SingleChildScrollView(
          child: Screenshot(
          controller: screenshotController,
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
                            decoration: new BoxDecoration(
                              border: new Border.all(color: Colors.transparent), //color is transparent so that it does not blend with the actual color specified
                              borderRadius: const BorderRadius.all(const Radius.circular(100)),
                              color: new Color.fromRGBO(0, 0, 0, 0.6),
                            ),
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
                            decoration: new BoxDecoration(
                              border: new Border.all(color: Colors.transparent), //color is transparent so that it does not blend with the actual color specified
                              borderRadius: const BorderRadius.all(const Radius.circular(30.0)),
                              color: new Color.fromRGBO(0, 0, 0, 0.6)
                            ),
                            child: Material(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.transparent,
                              child: IconButton(
                                splashRadius: 50,
                                icon: Icon(Icons.share, color: Colors.white,),
                                onPressed: () => _showSocialMediaShare(context, args.event, dateStart),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),  
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
                if(eventCommittee != null) {
                  for (int i = 0; i < eventCommittee.length; i++) {
                    if(user.uid == eventCommittee[i].userData[0]) {
                      myToast("Anda tidak dapat mengikuti event yang anda buat !", Colors.green[400]);
                      break;
                    } else if(i == eventCommittee.length - 1) {
                      Navigator.pushNamed(
                        context,
                        OrderPage.routeName,
                        arguments: OrderArguments(args.event),
                      );
                    }
                  }
                } else if(difference < 60) {
                  myToast("Segera daftar, Waktu pendaftaran tersisa $difference menit !", Colors.green[400]);
                } else {
                  Navigator.pushNamed(
                    context,
                    OrderPage.routeName,
                    arguments: OrderArguments(args.event),
                  );
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
