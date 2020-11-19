// import 'package:comat_apps/models/user.dart';
import 'package:comat_apps/models/event.dart';
import 'package:comat_apps/models/user.dart';
import 'package:comat_apps/models/user_detail.dart';
import 'package:comat_apps/ui/custom_widget/float_btn.dart';
import 'package:comat_apps/ui/event/event_list.dart';
import 'package:comat_apps/ui/home/user_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:comat_apps/services/database.dart';

class Home extends StatelessWidget {
  Home({Key key, this.title, this.drawer, this.splashscreen}) : super(key: key);
  final String title;
  final Widget drawer;
  final bool splashscreen;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Event>>.value(
          value: DatabaseService().events,
          catchError: (context, error) {
            print(error);
          },
          child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(title),
            leading: IconButton(
              icon: Icon(Icons.apps),
              onPressed: () => _scaffoldKey.currentState.openDrawer(),
            ),
          ),
          body: HomeBody(),
          drawer: drawer,
          floatingActionButton: FancyFab(icon: Icons.add, tooltip: 'Open Menu',),
      ),
    );
  }
}

class HomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(
        children: [
          _loginCard(user),
          EventList()
        ],
      ),
    );
  }

  _loginCard(User user) {
    if(user != null) {
      return StreamBuilder<UserDetail>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          UserDetail userDetail = snapshot.data;
          return userDetail == null ? Center(child: CircularProgressIndicator()) : Card(
            child: Column(
              children: [
                ListTile(
                  leading: Image.network(userDetail.avatar ?? "https://cdn2.iconfinder.com/data/icons/delivery-and-logistic/64/Not_found_the_recipient-no_found-person-user-search-searching-4-512.png",
                    width: 90,
                    height: 90,
                  ),
                  title: Text(userDetail.name) ?? Text(""),
                  subtitle: Text(
                    userDetail.email,
                    style: TextStyle(color: Colors.black.withOpacity(0.6)) ?? Text(""),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Hidup seperti air yang mengalir.',
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else {
      return Card(
        child: Column(
          children: [
            ListTile(
              title: const Text('Selamat Datang diaplikasi comat !'),
            )
          ],
        ),
      );
    }
  }
}

class _MenuContent extends StatelessWidget {
  _MenuContent({this.text, this.textSize, this.icon, this.iconSize, this.color});
  final String text;
  final double textSize;
  final IconData icon;
  final double iconSize;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: InkWell(
        onTap: () {
          // database.reference().child("message").set({
          //   "action" : "Clicked",
          //   "status" : "true",
          //   "aye": "aye"
          // });
        },
        splashColor: Colors.grey,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: iconSize, color: color),
              Text(text, style: TextStyle(fontSize: textSize))
            ],
          ),
        ),
      ),
    );
  }
}