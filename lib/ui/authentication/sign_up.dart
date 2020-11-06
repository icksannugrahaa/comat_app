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
  String email;
  String password;
  String error = '';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            // if(result == null) {
                            //   print('sign in anounymous error');
                            // } else {
                            //   print('sign in anounymous success');
                            //   print(result.uid);
                            // }
                            if(_formKey.currentState.validate()) {
                              print(email);
                              print(password);
                              dynamic result = await _authService.registerWithEmailAndPassword(email, password);
                              print(result);
                              if(result != null) {
                                // _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Login Gagal'),));
                                Navigator.pop(context);
                              } else {
                                error = "Email sudah digunakan !!";
                              }
                            }
                            //   var index = 0;
                            //   for(var element in _loginData) {
                            //     if(_data.email == element.email && _data.password == element.password) {
                            //       _showSnackBar(Text("Login sukses !"), Colors.greenAccent);
                            //       List<String> user = new List<String>();
                            //       user.add(element.name);
                            //       user.add(element.email);
                            //       Navigator.pop(context, user);
                            //         break;
                            //     } else {
                            //       debugPrint(_data.email);
                            //       debugPrint(element.password);
                            //       index+=1;
                            //       if(index == _loginData.length-1) {
                            //         _showSnackBar(Text("Login gagal !"), Colors.red);
                            //       }
                            //     }
                            //   }
                            // } else {
                            //   _showSnackBar(Text("Login gagal !"), Colors.red);
                            // }
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