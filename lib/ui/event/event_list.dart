import 'package:comat_apps/models/event.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:indonesia/indonesia.dart';

class EventList extends StatefulWidget {
  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  @override
  Widget build(BuildContext context) {
    final events = Provider.of<List<Event>>(context);

    return events == null ? Center(child: CircularProgressIndicator()) : ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: events.length ?? 1,
      itemBuilder: (context, index) {
        return EventTile(event: events[index]);
      },
    );
    
  }
}

class EventTile extends StatelessWidget {
  final Event event;
  EventTile({this.event});

  @override
  Widget build(BuildContext context) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(event.date.substring(18, 28)) * 1000);
    final date2 = DateTime.now();
    final difference = date.difference(date2).inDays;
    final percentace = (event.remains * 100) / event.limit;

    return Padding(
      padding: EdgeInsets.only(top: 8),
      child: Card(
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(event.image),
          ),
          title: Text(event.title, overflow: TextOverflow.ellipsis),
          subtitle: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 10),),
              Text(event.description, overflow: TextOverflow.ellipsis),
              Row(
                children: [
                  Chip(
                    avatar: CircleAvatar(
                      backgroundColor: difference >= 7 ? Colors.green : difference >= 5 ? Colors.orange[300] : Colors.red,
                      child: Icon(Icons.access_time, size: 14, color: Colors.white,),
                    ),
                    label: Text(tanggal(date),style: TextStyle(fontSize: 10),),
                  ),
                  Chip(
                    avatar: CircleAvatar(
                      backgroundColor: percentace >= 70 ? Colors.green : percentace >= 30 ? Colors.orange[300] : Colors.red,
                      child: percentace > 0 ? Icon(Icons.event_available, size: 14, color: Colors.white,) : Icon(Icons.event_busy, size: 14, color: Colors.white,),
                    ),
                    label: Text("${event.remains}",style: TextStyle(fontSize: 10),),
                  ),
                ],
              )
            ],
          ),
          onTap: () {},
        ),
      ),
    );
  }
}