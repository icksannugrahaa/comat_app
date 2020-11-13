import 'package:comat_apps/helpers/loading.dart';
import 'package:comat_apps/services/auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {

  final Function toogleView;
  SignUp({this.toogleView});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  bool loading = false;
  String email;
  String password;
  String error = '';
  
  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: ListView(
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Image.network("https://cdn.iconscout.com/icon/free/png-256/avatar-370-456322.png",
                      width: 90,
                      height: 90,
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
                    validator: (value) {
                      if(value.isEmpty) {
                        return "Tolong input email";
                      } else if(!RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(value)) {
                        return "Email tidak valid";
                      } else {
                        setState(() => email = value);
                        return null;
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
                      } else if(value.length < 6) {
                        return "Password minimal 6 digit";
                      } else {
                        setState(() => password = value);
                        return null;
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
                          onPressed: () async {
                            // dynamic result = await _authService.signInAnon();
                            if(_formKey.currentState.validate()) {
                              setState(() => loading = true);
                              dynamic result = await _authService.registerWithEmailAndPassword(email, password);
                              if(result == null) {
                                setState(() {
                                  error = "Email sudah digunakan !!";
                                  loading = false;
                                });
                              } else {
                                setState(() => loading = false);
                                Navigator.pop(context);
                              }
                            }
                          },
                          child: Text("Sign Up"),
                        ),

                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          onPressed: () {
                            widget.toogleView();
                          },
                          child: Text("Sign In"),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(error, style: TextStyle(color: Colors.red, fontSize: 14),),
                  ),
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}