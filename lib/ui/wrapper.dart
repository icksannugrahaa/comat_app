// System
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// My Package
import 'package:comat_apps/databases/db_users.dart';
import 'package:comat_apps/models/user.dart';
import 'package:comat_apps/models/user_detail.dart';
import 'package:comat_apps/ui/home/home.dart';

class Wrapper extends StatelessWidget {

  
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Home(title: "Comat App", drawer: _drawerMenu(context, user), user: user, dynamicLink: true,);
  }

  _drawerMenu (BuildContext context, final user) {

    if(user == null) {
        return Drawer(
          child: SafeArea(
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text("Home"),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.vpn_key),
                  title: Text("Sign In"),
                  onTap: () {
                    Navigator.pushNamed(context, '/login');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text("Pengaturan"),
                  onTap: () {
                    Navigator.pushNamed(context, '/setting');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text("Tentang Aplikasi"),
                  onTap: () {
                    Navigator.pushNamed(context, '/about');
                  },
                ),
              ]
            ),
          ),
        );
      } else {
        return StreamBuilder<UserDetail>(
          stream: DatabaseServiceUsers(uid: user.uid).userData,
          builder: (context, snapshot) {
            UserDetail userDetail = snapshot.data;
            return userDetail == null ? Center(child: CircularProgressIndicator()) : Drawer(
              child: SafeArea(
                child: ListView(
                  children: [
                    _UserAccDrawer(email: userDetail.email,name: userDetail.name, photoURL: userDetail.avatar),
                    ListTile(
                      leading: Icon(Icons.home),
                      title: Text("Home"),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text("Pengaturan"),
                      onTap: () {
                        Navigator.pushNamed(context, '/setting');
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.info_outline),
                      title: Text("Tentang Aplikasi"),
                      onTap: () {
                        Navigator.pushNamed(context, '/about');
                      },
                    ),
                  ]
                ),
              ),
            );
          }
        );
      }
  }
}

class _UserAccDrawer extends StatelessWidget {
  _UserAccDrawer({this.name, this.email, this.photoURL});
  final String name, email, photoURL;

  @override
  Widget build(BuildContext context) {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
          image: new DecorationImage(
            image: AssetImage("assets/images/bg_purple_mat.jpg"),
            fit: BoxFit.cover,
          ),
      ),
      accountName: Text(name),
      accountEmail: Text(email),
      currentAccountPicture: CircleAvatar(
        backgroundImage: NetworkImage(photoURL),
      ),
    );
  }
}