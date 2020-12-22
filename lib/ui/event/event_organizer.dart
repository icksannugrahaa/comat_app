// System
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// My Package
import 'package:comat_apps/databases/db_events.dart';
import 'package:comat_apps/models/event.dart';
import 'package:comat_apps/models/user.dart';
import 'package:comat_apps/ui/custom_widget/my_appbar.dart';
import 'package:comat_apps/ui/event/event_list.dart';

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

  @override
  void initState() {
    super.initState();
  }

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
    final user = Provider.of<User>(context);
    return StreamProvider<List<Event>>.value(
      value: DatabaseServiceEvents().myEvents(key,where,value,user.uid),
      child: Scaffold(
        appBar: MyAppBar(isSearchAble: true,setSearch: _setSearch,),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Daftar Event Saya",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
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