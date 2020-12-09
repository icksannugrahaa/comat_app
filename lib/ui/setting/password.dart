import 'package:comat_apps/databases/db_users.dart';
import 'package:comat_apps/models/user.dart';
import 'package:comat_apps/models/user_detail.dart';
import 'package:comat_apps/ui/custom_widget/my_appbar.dart';
import 'package:flutter/material.dart';

import 'package:comat_apps/services/auth.dart';
import 'package:comat_apps/ui/custom_widget/my_loading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:comat_apps/ui/custom_widget/my_input.dart';
import 'package:provider/provider.dart';

class SettingPassword extends StatefulWidget {
  @override
  _SettingPasswordState createState() => _SettingPasswordState();
}

class _SettingPasswordState extends State<SettingPassword> {
  AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();
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
    return loading == true ? Loading() : Scaffold(
      appBar: MyAppBar(),
      body: StreamBuilder<UserDetail>(
        stream: DatabaseServiceUsers(uid: user.uid).userData,
        builder: (context, snapshot) {
          UserDetail userDetail = snapshot.data;
          if(userDetail != null) {
            TextEditingController _emailC = TextEditingController(text: userDetail.email);
            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.only(left: 16, top: 25, right: 16),
                  child: ListView(
                    children: [
                      Text(
                        "Reset Password",
                        style: TextStyle(
                          fontSize: 25, fontWeight: FontWeight.w500
                        ),
                      ),
                      SizedBox(height: 35,),
                      NormalInput(isPassword: false,label: "Email",enable: false, inputType: TextInputType.emailAddress,controller: _emailC,),
                      SizedBox(height: 35,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OutlineButton(
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 2.2,
                                color: Colors.black
                              ),
                            ),
                          ),
                          RaisedButton(
                            onPressed: () async{
                              setState(() => loading = true );
                              await _auth.resetPassword(_emailC.text);
                              _showToast("Password reset was sent to email !", Colors.green);
                              setState(() => loading = false );
                            },
                            color: Colors.blue[400],
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              "Reset",
                              style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 2.2,
                                color: Colors.white
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        }
      ),
    );
  }
}