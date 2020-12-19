
import 'dart:ui' as ui;
import 'package:comat_apps/databases/db_events.dart';
import 'package:comat_apps/models/event.dart';
import 'package:comat_apps/ui/custom_widget/my_appbar.dart';
import 'package:comat_apps/ui/event/event_list.dart';
import 'package:flutter/material.dart';
import 'package:comat_apps/ui/constant.dart';

import 'package:provider/provider.dart';

class EventSearch extends StatefulWidget {
  @override
  _EventSearchState createState() => _EventSearchState();
}

class _EventSearchState extends State<EventSearch> {
  String key = '';
  String where = '';
  dynamic value = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchControl = new TextEditingController();
  var category = [
    {"colorStart": Colors.blue, "colorEnd": Colors.blue[100], "title": "All"},
    {"colorStart": Colors.blue, "colorEnd": Colors.blue[100], "title": "Band", "key": "type", "where":"isEqualTo", "value": "Music"},
    {"colorStart": Colors.blue, "colorEnd": Colors.blue[100], "title": "Seminar", "key": "type", "value": "Seminar", "where":"isEqualTo"},
    {"colorStart": Colors.blue, "colorEnd": Colors.blue[100], "title": "Webinar", "key": "type", "value": "Webinar", "where":"isEqualTo"},
    {"colorStart": Colors.blue, "colorEnd": Colors.blue[100], "title": "Workshop", "key": "type", "value": "Workshop", "where":"isEqualTo"},
  ];

  void _setSearch(String _key,String _where,dynamic _value) {
    setState(() {
      key = _key;
      where = _where;
      value = _value;
    });
    print(_value);
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Event>>.value(
      value: DatabaseServiceEvents().events(key,where,value),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: MyAppBar(isSearchAble: true, setSearch: _setSearch,),
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Search Event",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              height: 80.0,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                primary: false,
                itemCount: category == null ? 0.0 : category.length,
                itemBuilder: (BuildContext context, int i) {
                  return buildCategory(category[i]['colorStart'],category[i]['colorEnd'], category[i]['title'], category[i]['key'], category[i]['where'], category[i]['value']);
                },
              ),
            ),
            EventList(limit: 10,),
          ],
        ),
      ),
    );
  }

  Padding buildCategory(Color colorStart, Color colorEnd,String title, String _key, String _where, dynamic _value) {
    return Padding(
      padding: EdgeInsets.only(top: 15, right: 15, left: 15),
      child: Stack(
        children: [
          Stack(
            children: [
              Container(
                height: 50,
                width: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  gradient: LinearGradient(
                    colors: [
                      colorStart, colorEnd
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorStart,
                      blurRadius: 12,
                      offset: Offset(0,1)
                    )
                  ]
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        value = _value;
                        key = _key;
                        where = _where;
                      });
                    },
                    highlightColor: colorStart,
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                top: 0,
                child: CustomPaint(
                  painter: CustomCardShapePainter(radius: 15, startColor: colorStart, endColor: colorEnd),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15, left: 10),
                    child: Text(
                      title, 
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

class CustomCardShapePainter extends CustomPainter {
  final double radius;
  final Color startColor;
  final Color endColor;
  CustomCardShapePainter({this.radius, this.startColor, this.endColor});

  @override
  void paint(Canvas canvas, Size size) {
    var radius = 20.0;
    var paint = Paint();

    paint.shader = ui.Gradient.linear(
      Offset(0,0), 
      Offset(size.width, size.height), 
      [HSLColor.fromColor(startColor).withLightness(0.8).toColor(),endColor]
    );
    var path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width - radius, size.height)
      ..quadraticBezierTo(size.width, size.height, size.width, size.height - radius)
      ..lineTo(size.width, radius)
      ..quadraticBezierTo(size.width, 0, size.width - radius, 0)
      ..lineTo(size.width - 1.5 * radius, 0)
      ..quadraticBezierTo(-radius, 2*radius, 0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}