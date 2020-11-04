import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

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
  String name;
  String email;
  String imageUrl;

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
                ),
                Container(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SignInButton(
                        Buttons.Google,
                        text: "Sign up with Google",
                        onPressed: () {
                          signInWithGoogle().then((result) {
                            if (result != null) {
                              print(result);
                              Navigator.pop(context, result.user);
                            }
                          });
                        },
                      ),
                    )
                  ),
                ),
                Container(
                  child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          onPressed: () {
                            signOutGoogle();
                          },
                          child: Text("Logout"),
                        ),
                      )
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
  Future<UserCredential> signInWithGoogle() async {
    await Firebase.initializeApp();

    final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    final UserCredential authResult = await _auth.signInWithCredential(credential);
    final User user = authResult.user;

    if (user != null) {
      // Add the following lines after getting the user
      // Checking if email and name is null
      assert(user.email != null);
      assert(user.displayName != null);
      assert(user.photoURL != null);

      // Store the retrieved data
      name = user.displayName;
      email = user.email;
      imageUrl = user.photoURL;

      // Only taking the first part of the name, i.e., First Name
      if (name.contains(" ")) {
        name = name.substring(0, name.indexOf(" "));
      }

      print('signInWithGoogle succeeded: $user');

      return authResult;
    }

    return null;
  }
  void signOutGoogle() async{
    await _googleSignIn.signOut();

    print("User Signed Out");
  }
}
