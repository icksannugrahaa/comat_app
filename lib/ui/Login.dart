import 'package:flutter/material.dart';

class LoginData {
  final String email;
  final String password;
  final String name;

  LoginData(this.email, this.password, this.name);
}

class _LoginData {
  String email;
  String password;
}

class Login extends StatelessWidget {
  final String title;
  Login({Key key, this.title}) : super(key: key);
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Login'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              _displaySnackBar(context, "Account");
            },
          ),
        ],
      ),
      body: Center(child: LoginBody(),)
    );
  }
  _displaySnackBar(BuildContext context, String action) {
    final snackBar = SnackBar(
                      content: Text('You\'re clicked button $action'),
                      backgroundColor: Theme.of(context).backgroundColor,
                      duration: Duration(hours: 0, minutes: 0, seconds: 0, milliseconds: 500),
                    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}

class LoginBody extends StatefulWidget {
  @override
  LoginBodyState createState() => LoginBodyState();
}

class LoginBodyState extends State<LoginBody> {
  final _formKey = GlobalKey<FormState>();
  final _loginData = List<LoginData>.generate(10, (i) => LoginData("icksan$i@gmail.com","icksan$i","Icksan Nugraha $i"));
  _LoginData _data = _LoginData();

  LoginBodyState();

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'images/account.png',
                      width: 90,
                      height: 90,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25, bottom: 8),
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(
                            gapPadding: 3.3,
                            borderRadius: BorderRadius.circular(3.3)
                        )
                    ),
                    // ignore: missing_return
                    validator: (value) {
                      if(value.isEmpty) {
                        return "Tolong input email";
                      } else if(!RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(value)) {
                        return "Email tidak valid";
                      } else {
                        _data.email = value;
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25, bottom: 8),
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(
                            gapPadding: 3.3,
                            borderRadius: BorderRadius.circular(3.3)
                        )
                    ),
                    // ignore: missing_return
                    validator: (value) {
                      if(value.isEmpty) {
                        return "Tolong input password";
                      } else {
                        _data.password = value;
                      }
                    },
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: RaisedButton(
                          onPressed: () {
                            if(_formKey.currentState.validate()) {
                              var index = 0;
                              for(var element in _loginData) {
                                if(_data.email == element.email && _data.password == element.password) {
                                  _showSnackBar(Text("Login sukses !"), Colors.greenAccent);
                                  List<String> user = new List<String>();
                                  user.add(element.name);
                                  user.add(element.email);
                                  Navigator.pop(context, user);
                                    break;
                                } else {
                                  debugPrint(_data.email);
                                  debugPrint(element.password);
                                  index+=1;
                                  if(index == _loginData.length-1) {
                                    _showSnackBar(Text("Login gagal !"), Colors.red);
                                  }
                                }
                              }
                            } else {
                              _showSnackBar(Text("Login gagal !"), Colors.red);
                            }
                          },
                          child: Text("Login"),
                        ),

                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          onPressed: () {

                          },
                          child: Text("Register"),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      );
  }
  _showSnackBar(Text action, Color color) {
    return Scaffold.of(context)
        .showSnackBar(
        SnackBar(
          content: action,
          backgroundColor: color,
          duration: Duration(hours: 0, minutes: 0,seconds: 0, milliseconds: 400, microseconds: 0),
        )
    );
  }
}
