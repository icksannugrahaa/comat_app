import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  final String title;
  Home({Key key, this.title}) : super(key: key);
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              _displaySnackBar(context, "Account");
            },
          ),
        ],
      ),
      body: Center(child: HomeBody(),)
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

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return
      ListView(
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
                    validator: (value) {
                      if(value.isEmpty) {
                        return "Tolong input password";
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
                              Scaffold.of(context)
                                  .showSnackBar(
                                  SnackBar(
                                    content: Text("Login sukses !"),
                                    backgroundColor: Colors.lightGreen,
                                  )
                              );
                            } else {
                              Scaffold.of(context)
                                  .showSnackBar(
                                  SnackBar(
                                    content: Text("Login gagal !"),
                                    backgroundColor: Colors.red,
                                  )
                              );
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
}

class _LoginData {
  String email = "";
  String password = "";
}