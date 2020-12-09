import 'package:comat_apps/models/event.dart';
import 'package:comat_apps/ui/event/event_argument.dart';
import 'package:flutter/material.dart';
import 'package:comat_apps/ui/constant.dart';
import '../custom_widget/ui_helper.dart';
import 'package:intl/intl.dart';

class EventDetail extends StatefulWidget {
  final Event event;
  static const routeName = '/event-detail';

  EventDetail({Key key, this.event}) : super(key: key);

  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  
  @override
  Widget build(BuildContext context) {

    final EventArguments args = ModalRoute.of(context).settings.arguments;
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(args.event.date.substring(18, 28)) * 1000);
    final dateStart = DateTime.fromMillisecondsSinceEpoch(int.parse(args.event.timeStart.substring(18, 28)) * 1000);
    final dateEnd = DateTime.fromMillisecondsSinceEpoch(int.parse(args.event.timeEnd.substring(18, 28)) * 1000);
    // final date2 = DateTime.now();
    // final difference = date.difference(date2).inDays;
    // final percentace = (args.event.remains * 100) / args.event.limit;
    final timestart = DateFormat('Hms').format(dateStart);
    final timeend = DateFormat('Hms').format(dateEnd);
    final String tanggal = DateFormat('dd').format(date);
    final String bulan = DateFormat('MMM').format(date);
    final String hari = DateFormat('EEEE').format(date);
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
  print(timestart);
    return Scaffold(
      body: SingleChildScrollView(
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
                                Text(bulan,
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
                              Text(hari,
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
                      "Event Detail :",
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
                      "Location :",
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
                    SizedBox(height: 40,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Ticket Remains :",
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 13,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                            Text(
                              "${args.event.remains} from ${args.event.limit}",
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

                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          color: args.event.status == true ? Colors.green[400] : Colors.red,
                          padding: EdgeInsets.all(15),
                          child: Text(
                            args.event.status == true ? "Attend" : "Unavailable",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18
                            ),
                          ),    
                        )
                      ],
                    )
                  ],
                ),
              ),
              // Positioned(
              //   left: 10,
              //   top: height*0.05,
              //   child: IconButton(
              //     icon: Icon(Icons.arrow_back),
              //     onPressed: () {
              //       Navigator.pop(context);
              //     },
              //     color: Colors.white,
              //   ),
              // )
              Padding(
                padding: const EdgeInsets.only(top: 45, left: 20),
                child: Align(
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
              ),
            ],
          ),  
        )
        // child: Column(
        //   children: [
        //     Header(
        //       decorationImg: '',
        //       textOrImg: false,
        //       textSize: 0,
        //       titleImage: args.event.image,
        //       titleText: "",
        //       online: true,
        //       icon: Icons.arrow_back
        //     ),
        //     SizedBox(
        //     height: MediaQuery.of(context).size.height-400,
        //     child: Stack(
        //       children: [
        //         Container(
        //           height: MediaQuery.of(context).size.height,
        //           width: double.infinity,
        //           decoration: BoxDecoration(
        //             borderRadius: BorderRadius.circular(20),
        //             color: Colors.white,
        //             boxShadow: [
        //               BoxShadow(
        //                 offset: Offset(0, 8),
        //                 blurRadius: 24,
        //                 color: kShadowColor
        //               )
        //             ]
        //           ),
        //         ),
        //         Container(
        //           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             children: [
        //               Text(
        //                 args.event.title, 
        //                 style: kTitleTextStyle.copyWith(
        //                   fontSize: 18
        //                 ),
        //               ),
        //               Row(
        //                 children: [
        //                   Chip(
        //                     avatar: CircleAvatar(
        //                       backgroundColor: difference >= 7 ? Colors.green : difference >= 5 ? Colors.orange[300] : Colors.red,
        //                       child: Icon(Icons.access_time, size: 14, color: Colors.white,),
        //                     ),
        //                     label: Text(tanggal(date),style: TextStyle(fontSize: 10),),
        //                   ),
        //                 ],
        //               ),
        //               Flexible(
        //                 child: Text(
        //                   args.event.description,
        //                   style: TextStyle(
        //                     fontSize: 14
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        //   ]
        // ),
      ),
    );
  }

}
