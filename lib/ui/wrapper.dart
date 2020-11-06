import 'package:comat_apps/models/user.dart';
import 'package:comat_apps/services/auth.dart';
import 'package:comat_apps/ui/authentication/authenticate.dart';
import 'package:comat_apps/ui/home/home.dart';
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
                _ListTile(icon: Icons.home,title: 'Home'),
                ListTile(
                  leading: Icon(Icons.vpn_key),
                  title: Text("Sign In"),
                  onTap: () async {
                    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => Authenticate()));
                    print(result);
                    print("suceess login");
                  },
                ),
                _ListTile(icon: Icons.info_outline,title: 'About'),
              ]
            ),
          ),
        );
      } else {
        return Drawer(
          child: SafeArea(
            child: ListView(
              children: [
                _UserAccDrawer(email: "icksannugrahaa@gmail.com",name: "Icksan Nugraha", photoURL: "https://cdn.iconscout.com/icon/free/png-256/avatar-370-456322.png",),
                _ListTile(icon: Icons.home,title: 'Home'),
                _ListTile(icon: Icons.account_circle,title: 'Profile'),
                _ListTile(icon: Icons.info_outline,title: 'About'),
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