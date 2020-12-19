import 'package:comat_apps/databases/db_users.dart';
import 'package:comat_apps/models/user.dart';
import 'package:comat_apps/models/user_detail.dart';
import 'package:comat_apps/services/auth.dart';
import 'package:comat_apps/ui/custom_widget/my_appbar.dart';
import 'package:comat_apps/ui/custom_widget/my_loading.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final AuthService _auth = AuthService();
  bool loading = false;
  
  _showToast(String text, Color bgcolor) {
    return Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: bgcolor,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    
    if(user != null) {
      return loading ? Loading() : Scaffold(
        appBar: MyAppBar(),
        body: StreamBuilder<UserDetail>(
          stream: DatabaseServiceUsers(uid: user.uid).userData,
          builder: (context, snapshot) {
            UserDetail userDetail = snapshot.data;
            if(userDetail != null && userDetail.gSignIn == false) {
              return Container(
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16, top: 25, right: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Settings",
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.person,
                                color: Colors.blue[400],
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                "Account",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Divider(
                            height: 15,
                            thickness: 2,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SettingAccountTile(route: "/reset-password", title: "Reset Password",),
                          SettingAccountTile(route: "/profile", title: "Edit Profile",),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.volume_up,
                                color: Colors.blue[400],
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                "Notifications",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Divider(
                            height: 15,
                            thickness: 2,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          buildNotificationOptionRow("Event Remainder", true),
                          SizedBox(
                            height: 50,
                          ),
                          Center(
                            child: OutlineButton(
                              padding: EdgeInsets.symmetric(horizontal: 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                              ),
                              onPressed: () async {
                                await _auth.signOut();
                                _showToast("Logout successfully !", Colors.green);
                                Navigator.pushReplacementNamed(context, "/home");
                              },
                              child: Text(
                                "SIGN OUT",
                                style: TextStyle(fontSize: 16, letterSpacing: 2.2, color: Colors.black)
                              ),
                            ),
                          )
                        ], 
                      ),
                    )
                  ],
                ),
              );
            } else {
              return Container(
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16, top: 25, right: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Settings",
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.volume_up,
                                color: Colors.blue[400],
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                "Notifications",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Divider(
                            height: 15,
                            thickness: 2,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          buildNotificationOptionRow("Event Remainder", true),
                          SizedBox(
                            height: 50,
                          ),
                          Center(
                            child: OutlineButton(
                              padding: EdgeInsets.symmetric(horizontal: 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                              ),
                              onPressed: () async {
                                await _auth.signOut();
                                _showToast("Logout successfully !", Colors.green);
                                Navigator.pushReplacementNamed(context, "/home");
                              },
                              child: Text(
                                "SIGN OUT",
                                style: TextStyle(fontSize: 16, letterSpacing: 2.2, color: Colors.black)
                              ),
                            ),
                          )
                        ], 
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 1,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.keyboard_backspace,
              color: Colors.blue[400],
            ),
          ),
        ),
        body: Container(
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16, top: 25, right: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Settings",
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.volume_up,
                          color: Colors.blue[400],
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Notifications",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Divider(
                      height: 15,
                      thickness: 2,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    buildNotificationOptionRow("Event Remainder", true),
                  ], 
                ),
              )
            ],
          ),
        ),
      );
    }
  }

  Row buildNotificationOptionRow(String title, bool isActive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600]
          ),
        ),
        Transform.scale(
          scale: 0.7,
          child: Switch(
            value: isActive,
            onChanged: (bool val) {},
          )
        )
      ],
    );
  }
}

class SettingAccountTile extends StatelessWidget {
  const SettingAccountTile({
    Key key,
    this.route,
    this.title
  }) : super(key: key);
  final String title;
  final String route;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      contentPadding: EdgeInsets.only(left: 0, right: 0),
      trailing: Icon(Icons.arrow_forward_ios),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.grey[600]
        ),
      ),
    );
  }
}