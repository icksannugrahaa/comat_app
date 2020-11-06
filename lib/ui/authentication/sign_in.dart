import 'package:comat_apps/helpers/loading.dart';
import 'package:comat_apps/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class SignIn extends StatefulWidget {

  final Function toogleView;
  SignIn({this.toogleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService(); 
  bool loading = false;
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
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
                              dynamic result = await _authService.signInWithEmailAndPassword(email, password);
                              if(result == null) {
                                print('sign in email and password error');
                                setState(() {
                                  error = "your credential doesn't match";
                                  loading = false;
                                });
                              } else {
                                print('sign in email and password success');
                                print(result.uid);
                                Navigator.pop(context);
                              }
                            }
                          },
                          child: Text("Sign In"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          onPressed: () {
                            widget.toogleView();
                          },
                          child: Text("Sign Up"),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SignInButton(
                        Buttons.Google,
                        padding: EdgeInsets.only(left: 25.0),
                        onPressed: () async{
                          dynamic result = await _authService.signInWithGoogle();
                          // setState(() => loading = true);
                          if(result == null) {
                            print('sign in google error');
                            // setState(() {
                            //   error = "sign in google error";
                            //   loading = false;
                            // });
                          } else {
                            print('sign in google success');
                            print(result.uid);
                            Navigator.pop(context);
                          }
                        },
                      )
                    )
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