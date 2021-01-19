// System
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// My Package
import 'package:comat_apps/databases/db_events.dart';
import 'package:comat_apps/models/event.dart';
import 'package:comat_apps/ui/custom_widget/my_appbar.dart';
import 'package:comat_apps/ui/custom_widget/my_shape.dart';
import 'package:comat_apps/ui/event/event_list.dart';
import 'package:comat_apps/ui/constant.dart';

class EventSearch extends StatefulWidget {
  final String keys;
  final String where;
  final dynamic value;
  EventSearch({this.keys, this.value, this.where});
  @override
  _EventSearchState createState() => _EventSearchState();
}

class _EventSearchState extends State<EventSearch> {
  String _key = '';
  String _where = '';
  dynamic _value = '';

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  
  void _setSearch(String _key,String _where,dynamic _value) {
    setState(() {
      _key = _key;
      _where = _where;
      _value = _value;
    });
  }

  @override
  Widget build(BuildContext context) {
                      print(_value);
                      print(_key);
                      print(_where);
    return StreamProvider<List<Event>>.value(
      value: DatabaseServiceEvents().events(_key,_where,_value),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: MyAppBar(isSearchAble: true, setSearch: _setSearch,),
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Cari Event",
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

  Padding buildCategory(Color colorStart, Color colorEnd,String title, String key, String where, dynamic value) {
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
                        _value = value;
                        _key = key;
                        _where = where;
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