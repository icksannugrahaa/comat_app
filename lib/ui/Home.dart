import 'package:flutter/material.dart';
import 'Login.dart';

class Home extends StatelessWidget {
  Home({Key key, this.title}) : super(key: key);
  final String title;
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
        drawer: _DrawerMenu(),
    );
  }
}

class HomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      children: [
        _MenuContent(text: "Jadwal", text_size: 19, icon: Icons.calendar_today, icon_size: 100, color: Colors.black),
        GridView.count(
            crossAxisCount: 2,
            children: [
              _MenuContent(text: "Jadwal", text_size: 12, icon: Icons.calendar_today, icon_size: 30, color: Colors.black),
              _MenuContent(text: "Jadwal", text_size: 12, icon: Icons.calendar_today, icon_size: 30, color: Colors.black),
              _MenuContent(text: "Jadwal", text_size: 12, icon: Icons.calendar_today, icon_size: 30, color: Colors.black),
              _MenuContent(text: "Jadwal", text_size: 12, icon: Icons.calendar_today, icon_size: 30, color: Colors.black),
            ],
        )
      ],
    );
  }
}

class _DrawerMenu extends StatelessWidget {
//  _UserData _userData = new _UserData(kelas: "A1", email: "icksannugrahaa@gmail.com", name: "Icksan Nugraha");
    _UserData _userData = new _UserData();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
                image: new DecorationImage(
                  image: AssetImage("images/bg_purple_mat.jpg"),
                  fit: BoxFit.cover,
                ),
            ),
            accountName: (_userData.name != null) ? Text(_userData.name) : Text(""),
            accountEmail: (_userData.email  != null) ? Text(_userData.email) : Text(""),
            currentAccountPicture: (_userData.name  != null) ? CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                "I",
                style: TextStyle(fontSize: 40.0),
              ),
            ) : CircleAvatar(
              backgroundColor: Colors.white,
              child: Image.asset('images/circle_account.png',color: Colors.black54,),
            ),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: (_userData.name != null ? Text('Profile') : Text('Login')),
            onTap: () {
              if(_userData.name == null) {
                _navigateAndDisplaySelection(context);
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
        ],
      ),
    );
  }
  _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
    _userData.email = result[0];
    _userData.name = result[1];
  }
}

class _MenuContent extends StatelessWidget {
  _MenuContent({this.text, this.text_size, this.icon, this.icon_size, this.color});
  final String text;
  final double text_size;
  final IconData icon;
  final double icon_size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: InkWell(
        onTap: () {

        },
        splashColor: Colors.grey,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: icon_size, color: color),
              Text(text, style: TextStyle(fontSize: text_size))
            ],
          ),
        ),
      ),
    );
  }
}

class _UserData {
  _UserData({this.email, this.name});
  String email;
  String name;
}