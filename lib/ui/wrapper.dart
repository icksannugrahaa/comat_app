import 'package:comat_apps/models/user.dart';
import 'package:comat_apps/models/user_detail.dart';
import 'package:comat_apps/services/auth.dart';
import 'package:comat_apps/services/database.dart';
import 'package:comat_apps/ui/about/about.dart';
import 'package:comat_apps/ui/authentication/authenticate.dart';
import 'package:comat_apps/ui/home/home.dart';
import 'package:comat_apps/ui/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    // if(user == null) {
    //   return Authenticate();
    // } else {
      return Home(title: "Comat App", drawer: _drawerMenu(context, user),);
    // }
    // return user != null ? Home() : Authenticate();
  }

  _drawerMenu (BuildContext context, final user) {
    final AuthService _auth = AuthService();

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
                  onTap: () async {
                    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => Authenticate()));
                    print(result);
                    print("suceess login");
                  },
                ),
                ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text("About"),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => About()));
                  },
                ),
              ]
            ),
          ),
        );
      } else {
        return StreamBuilder<UserDetail>(
          stream: DatabaseService(uid: user.uid).userData,
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
                      leading: Icon(Icons.account_circle),
                      title: Text("Profile"),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.info_outline),
                      title: Text("About"),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => About()));
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.exit_to_app),
                      title: Text("Sign Out"),
                      onTap: () async {
                        await _auth.signOut();
                      },
                    )
                  ]
                ),
              ),
            );
          }
        );
      }
  }
}

class _ListTile extends StatelessWidget {
  _ListTile({this.icon, this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
      }
    );
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
            image: AssetImage("images/bg_purple_mat.jpg"),
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