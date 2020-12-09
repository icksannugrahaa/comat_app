import 'package:comat_apps/databases/db_events.dart';
import 'package:comat_apps/models/event.dart';
import 'package:comat_apps/ui/custom_widget/my_appbar.dart';
import 'package:comat_apps/ui/event/event_category.dart';
import 'package:comat_apps/ui/event/event_list.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class EventSearch extends StatefulWidget {
  @override
  _EventSearchState createState() => _EventSearchState();
}

class _EventSearchState extends State<EventSearch> {
  final TextEditingController _searchControl = new TextEditingController();
  var category = [
    {"colorStart": Colors.blue, "colorEnd": Colors.blue[100], "title": "Band"},
    {"colorStart": Colors.blue, "colorEnd": Colors.blue[100], "title": "Seminar"},
    {"colorStart": Colors.blue, "colorEnd": Colors.blue[100], "title": "Webinar"},
    {"colorStart": Colors.blue, "colorEnd": Colors.blue[100], "title": "Workshop"},
  ];
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Event>>.value(
      value: DatabaseServiceEvents().events,
      child: Scaffold(
        appBar: MyAppBar(),
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Search Event",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blueGrey[50],
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: TextField(
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.blueGrey[300],
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: "E.g: New York, United States",
                    prefixIcon: Icon(
                      Icons.location_on,
                      color: Colors.blueGrey[300],
                    ),
                    hintStyle: TextStyle(
                      fontSize: 15.0,
                      color: Colors.blueGrey[300],
                    ),
                  ),
                  maxLines: 1,
                  controller: _searchControl,
                ),
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
                  return EventCategory(title: category[i]['title'],colorEnd: category[i]['colorEnd'],colorStart: category[i]['colorStart'],);
                },
              ),
            ),
            EventList(limit: 10,),
          ],
        ),
      ),
    );
  }
}