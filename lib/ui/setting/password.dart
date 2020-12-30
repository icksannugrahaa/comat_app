// System
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// My Package
import 'package:comat_apps/databases/db_users.dart';
import 'package:comat_apps/models/user.dart';
import 'package:comat_apps/models/user_detail.dart';
import 'package:comat_apps/ui/custom_widget/my_appbar.dart';
import 'package:comat_apps/services/auth.dart';
import 'package:comat_apps/ui/custom_widget/my_loading.dart';
import 'package:comat_apps/ui/custom_widget/my_input.dart';
import 'package:comat_apps/ui/custom_widget/my_toast.dart';

class SettingPassword extends StatefulWidget {
  @override
  _SettingPasswordState createState() => _SettingPasswordState();
}

class _SettingPasswordState extends State<SettingPassword> {
  AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return loading == true ? Loading() : Scaffold(
      appBar: MyAppBar(isSearchAble: false,),
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
                  child: ListView(
                    padding: EdgeInsets.all(20),
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
                          RaisedButton(
                            onPressed: () async{
                              setState(() => loading = true );
                              await _auth.resetPassword(_emailC.text);
                              myToast("Reset password sudah dikirim ke email anda !", Colors.green);
                              setState(() => loading = false );
                            },
                            color: Colors.blue[400],
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: Text(
                              "Reset",
                              style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 2.2,
                                color: Colors.white
                              ),
                            ),
                          ),
                          OutlineButton(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Batalkan",
                              style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 2.2,
                                color: Colors.black
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Container();
          }
        }
      ),
    );
  }
}