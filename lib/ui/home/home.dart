import 'package:comat_apps/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  Home({Key key, this.title, this.drawer}) : super(key: key);
  final String title;
  final Drawer drawer;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(title),
          leading: IconButton(
            icon: Icon(Icons.apps),
            onPressed: () => _scaffoldKey.currentState.openDrawer(),
          ),
        ),
        body: Center(child: HomeBody(),),
        drawer: drawer,
    );
  }
}

class HomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: _loginCard(user)
        ),
        GridView.count(
          shrinkWrap: true,   
          physics: ClampingScrollPhysics(),
          crossAxisCount: 2,
          children: [
            _MenuContent(text: "Jadwal", textSize: 19, icon: Icons.calendar_today, iconSize: 100, color: Colors.black),
            GridView.count(
                crossAxisCount: 2,
                children: [
                  _MenuContent(text: "Jadwal", textSize: 12, icon: Icons.calendar_today, iconSize: 30, color: Colors.black),
                  _MenuContent(text: "Jadwal", textSize: 12, icon: Icons.calendar_today, iconSize: 30, color: Colors.black),
                  _MenuContent(text: "Jadwal", textSize: 12, icon: Icons.calendar_today, iconSize: 30, color: Colors.black),
                  _MenuContent(text: "Jadwal", textSize: 12, icon: Icons.calendar_today, iconSize: 30, color: Colors.black),
                ],
            )
          ],
        )
      ],
    );
  }

  _loginCard(User user) {
    if(user != null) {
      return Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            ListTile(
              leading: Image.network("https://cdn.iconscout.com/icon/free/png-256/avatar-370-456322.png",
                width: 90,
                height: 90,
              ),
              title: const Text('Icksan Nugraha'),
              subtitle: Text(
                'icksannugrahaa@gmail.com',
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
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
    } else {
      return Card(
        clipBehavior: Clip.antiAlias,
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