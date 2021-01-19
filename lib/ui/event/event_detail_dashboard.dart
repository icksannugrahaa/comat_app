import 'package:comat_apps/databases/db_event_committee.dart';
import 'package:comat_apps/models/event.dart';
import 'package:comat_apps/models/event_committee.dart';
import 'package:comat_apps/models/user.dart';
import 'package:comat_apps/ui/custom_widget/my_toast.dart';
import 'package:flutter/material.dart';
import 'package:comat_apps/ui/constant.dart';
import 'package:provider/provider.dart';
import 'package:social_share/social_share.dart';

class EventDetailDashboard extends StatefulWidget {
  final Event event;
  EventDetailDashboard({this.event});
  @override
  _EventDetailDashboardState createState() => _EventDetailDashboardState();
}

class _EventDetailDashboardState extends State<EventDetailDashboard> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    final user = Provider.of<User>(context);

    return StreamProvider<List<EventCommittee>>.value(
      value: DatabaseServiceEventCommittee().myEventsCommitee('committeeCode', widget.event.committeeCode, user.uid),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                buildCard('Pembayaran Masuk', 'Rp. 100.000', Colors.blue[400]),
              ],
            ),
            Row(
              children: [
                buildCard('Tiket Terjual', '20', Colors.orange[400]),
                buildCard('Tiket Tersisa', '120', Colors.green[400]),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Panitia",
                        style: kTitleTextStyle,
                      ),
                    ],
                  ),
                ),
                Spacer(),
                InkWell(
                    onTap: () {
                      SocialShare.copyToClipboard(
                        "Event ${widget.event.title} \nDiselengarakan oleh ${widget.event.organizer} \nSegera install aplikasi dan daftarkan diri anda sebagai panitia dengan memasukan kode ${widget.event.committeeCode}",
                      ).then((data) {
                        print(data);
                      });
                      myToast("Kode telah disalin !", Colors.green[400]);
                    },
                    child: Text(
                      "Salin Kode Panitia",
                      style: TextStyle(
                          color: kPrimaryColor, fontWeight: FontWeight.w600),
                    )),
              ],
            ),
            ListCommittee()
          ],
        ),
      ),
    );
  }

  Expanded buildCard(String title, String sub, Color color) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(10),
        height: 100,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w600)),
            Text(sub,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }
}

class ListCommittee extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _events = Provider.of<List<EventCommittee>>(context);
    return _events == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            padding: EdgeInsets.all(5),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _events.length ?? 1,
            itemBuilder: (context, index) {
              return ListTile(
                  title: Text(_events[index].userData[1]),
                  subtitle: Text(_events[index].level),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(_events[index].userData[3]),
                  ));
            },
          );
  }
}
