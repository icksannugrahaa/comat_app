import 'package:comat_apps/models/event.dart';
import 'package:comat_apps/ui/event/event_argument.dart';
import 'package:comat_apps/ui/event/event_detail_dashboard.dart';
import 'package:comat_apps/ui/event/event_detail_participant.dart';
import 'package:flutter/material.dart';

class EventDetailManagement extends StatefulWidget {
  final Event event;
  static const routeName = '/event-detail-management';
  EventDetailManagement({Key key, this.event}) : super(key: key);
  @override
  _EventDetailManagementState createState() => _EventDetailManagementState();
}

class _EventDetailManagementState extends State<EventDetailManagement> {
  @override
  Widget build(BuildContext context) {
    final EventArguments args = ModalRoute.of(context).settings.arguments;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          bottom: TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black38,
            tabs: [
              Tab(icon: Icon(Icons.dashboard)),
              Tab(icon: Icon(Icons.group)),
              Tab(icon: Icon(Icons.analytics)),
            ],
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.keyboard_backspace,
              color: Colors.black,
            ),
          ),
          title: Text(
            'Event Detail',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: TabBarView(
          children: [
            EventDetailDashboard(event: args.event,),
            EventDetailParticipant(event: args.event,),
            Center(child: Text("Belum tersedia !", style: TextStyle(fontSize: 24),)),
          ],
        ),
      ),
    );
  }
}
