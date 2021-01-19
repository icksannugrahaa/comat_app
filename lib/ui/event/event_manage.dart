import 'package:comat_apps/models/event.dart';
import 'package:comat_apps/ui/event/event_create.dart';
import 'package:comat_apps/ui/event/event_organizer.dart';
import 'package:flutter/material.dart';

class EventManage extends StatefulWidget {
  @override
  _EventManageState createState() => _EventManageState();
}

class _EventManageState extends State<EventManage> {
  int _selectedPage = 0;
  double total = 3;
  Event myEvent = Event();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void setSelectedEvent(Event e) {
    setState(() {
      myEvent = e;
    });
  }
  
  void setSelectedPage(int i) {
    setState(() {
      _selectedPage = i;
    });
  }

  Widget _listPage(int index) {
    switch (index) {
      case 0:
        setSelectedEvent(null);
        return EventOrganizer(setSelectedEvent: setSelectedEvent, setSelectedPage: setSelectedPage, eventData: myEvent,);
        break;
      case 1:
        return EventCreate(myEvent: myEvent,setSelectedPage: setSelectedPage,);
        break;
      case 2:
        setSelectedEvent(null);
        return Center(child: Text("Belum tersedia !", style: TextStyle(fontSize: 24),));
        break;
      default:
        return EventOrganizer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      bottomNavigationBar: Row(
        children: [
          buildNavBarItem(Icons.home, 0),
          buildNavBarItem(Icons.post_add, 1),
          buildNavBarItem(Icons.update, 2),
        ],
      ),
      body: Container(
        child: _listPage(_selectedPage),
      )
    );
  }

  GestureDetector buildNavBarItem(IconData icon, int index) {
    return GestureDetector(
      onTap: () {
        setSelectedPage(index);
      },
      child: Container(
        width: MediaQuery.of(context).size.width / total,
        height: 60,
        decoration: index == _selectedPage
          ? BoxDecoration(
              border:
                  Border(bottom: BorderSide(width: 4, color: Colors.blue)),
              gradient: LinearGradient(colors: [
                Colors.blue.withOpacity(0.3),
                Colors.blue.withOpacity(0.016),
              ], begin: Alignment.bottomCenter, end: Alignment.topCenter))
          : BoxDecoration(),
        child: Icon(
          icon,
          color: index == _selectedPage ? Colors.blue[300] : Colors.grey,
        ),
      ),
    );
  }
}