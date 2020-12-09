import 'package:comat_apps/models/event.dart';
import 'package:comat_apps/ui/event/event_argument.dart';
import 'package:comat_apps/ui/event/event_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:indonesia/indonesia.dart';
import 'package:comat_apps/ui/constant.dart';

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
        if(index < 4) {
          return EventTile(event: events[index]);
        } else {
          return Container();
        }
      },
    );
  }
}

class EventTile extends StatelessWidget {
  const EventTile({
    Key key, this.event
  }) : super(key: key);

  final Event event;

  @override
  Widget build(BuildContext context) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(event.date.substring(18, 28)) * 1000);
    final date2 = DateTime.now();
    final difference = date.difference(date2).inDays;
    final percentace = (event.remains * 100) / event.limit;

    return ClipRect(
      child: Banner(
        message: "${event.remains} slot",
        location: BannerLocation.topEnd,
        textStyle: TextStyle(fontSize: 10),
        color: percentace >= 70 ? Colors.green : percentace >= 30 ? Colors.orange[300] : Colors.red,
        child: SizedBox(
          height: 156,
          child: Stack(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    EventDetail.routeName,
                    arguments: EventArguments(event),
                  );
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 136,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white.withOpacity(0.8),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 8),
                        blurRadius: 24,
                        color: kShadowColor
                      )
                    ]
                  ),
                ),
              ),
              Image.network(event.image, height: 120, width: 140,),
              Positioned(
                left: 130,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  height: 136,
                  width: MediaQuery.of(context).size.width - 170,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        event.title, 
                        style: kTitleTextStyle.copyWith(
                          fontSize: 16
                        ),
                        overflow: TextOverflow.ellipsis
                      ),
                      Flexible(
                        child: Text(
                          event.description,
                          style: TextStyle(
                            fontSize: 12
                          ),
                          overflow: TextOverflow.ellipsis
                        ),
                      ),
                      Row(
                        children: [
                          Chip(
                            avatar: CircleAvatar(
                              backgroundColor: difference >= 7 ? Colors.green : difference >= 5 ? Colors.orange[300] : Colors.red,
                              child: Icon(Icons.access_time, size: 14, color: Colors.white,),
                            ),
                            label: Text(tanggal(date),style: TextStyle(fontSize: 10),),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}