import 'package:comat_apps/databases/db_order.dart';
import 'package:comat_apps/models/event.dart';
import 'package:comat_apps/models/order.dart';
import 'package:comat_apps/ui/custom_widget/my_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventDetailParticipant extends StatefulWidget {
  final Event event;
  EventDetailParticipant({this.event});
  @override
  _EventDetailParticipantState createState() => _EventDetailParticipantState();
}

class _EventDetailParticipantState extends State<EventDetailParticipant> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Order>>.value(
      value: DatabaseServiceOrders().orders('', '', '', widget.event.eid),
      child: Container(child: ListParticipant()),
    );
  }
}

class ListParticipant extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _events = Provider.of<List<Order>>(context);
    return _events == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : _events.length == 0
            ? Center(
                child: Text(
                  "Tidak ada peserta :(",
                  style: TextStyle(fontSize: 24),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Peserta',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.all(5),
                      shrinkWrap: true,
                      itemCount: _events.length ?? 1,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_events[index].userData[1]),
                          subtitle: Text(_events[index].userData[2]),
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(_events[index].userData[3]),
                          ),
                          trailing: _events[index].status.contains("Menunggu")
                              ? IconButton(
                                  icon: Icon(Icons.access_time,
                                      color: _events[index]
                                              .status
                                              .contains("Menunggu pembayaran")
                                          ? Colors.red
                                          : Colors.orange),
                                  tooltip: _events[index].status,
                                  onPressed: () =>
                                      myToast(_events[index].status, Colors.grey),
                                )
                              : IconButton(
                                  icon: Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  ),
                                  tooltip: _events[index].status,
                                  onPressed: () => myToast(
                                      _events[index].status, Colors.grey),
                                ),
                        );
                      },
                    ),
                  ],
                ),
              );
  }
}
