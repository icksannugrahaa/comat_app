import 'package:comat_apps/ui/authentication/sign_in.dart';
import 'package:comat_apps/ui/authentication/sign_up.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = true;
  void toogleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: !showSignIn ? SignUp(toogleView: toogleView) : SignIn(toogleView: toogleView),
    );
  }
}