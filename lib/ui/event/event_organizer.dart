import 'package:comat_apps/databases/db_events.dart';
import 'package:comat_apps/models/event.dart';
import 'package:comat_apps/models/user.dart';
import 'package:comat_apps/ui/custom_widget/my_appbar.dart';
import 'package:comat_apps/ui/event/event_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventOrganizer extends StatefulWidget {
  final Event eventData;
  final Function setSelectedEvent;
  final Function setSelectedPage;
  EventOrganizer({this.setSelectedEvent, this.setSelectedPage, this.eventData});

  @override
  _EventOrganizerState createState() => _EventOrganizerState();
}

class _EventOrganizerState extends State<EventOrganizer> {
  String key = '';
  String where = '';
  dynamic value = '';
  final TextEditingController _searchControl = new TextEditingController();


  @override
  void initState() {
    //StartFunc();
    super.initState();
    // if(widget.eventData != null) {
    //   widget.setSelectedEvent(null);
    // }
  }
  
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamProvider<List<Event>>.value(
      value: DatabaseServiceEvents().myEvents(key,where,value,user.uid),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "MY Event",
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
                      hintText: "Search...",
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.blueGrey[300],
                      ),
                      hintStyle: TextStyle(
                        fontSize: 15.0,
                        color: Colors.blueGrey[300],
                      ),
                    ),
                    maxLines: 1,
                    controller: _searchControl,
                    onSubmitted: (_value) {
                      setState(() {
                        value = _value;
                        key = 'title';
                        where = 'isEqualTo';
                      });
                    },
                  ),
                ),
              ),
              EventList(limit: 10, isManage: true, setSelectedEvent:widget.setSelectedEvent, setSelectedPage: widget.setSelectedPage,),
            ],
          ),
        ),
      ),
    ); 
  }
}