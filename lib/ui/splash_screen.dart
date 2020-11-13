import 'dart:async';
import 'package:comat_apps/ui/authentication/sign_in.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void initState() {
    super.initState();
    startLaunching();
  }

  startLaunching() async {
    var duration = const Duration(seconds: 10);
    return new Timer(duration, () {
      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (_) {
        return new SignIn();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.network(
          "https://www.dicoding.com/blog/wp-content/uploads/2017/10/dicoding-logo-square.png",
          height: 100.0,
          width: 200.0,
        ),
      ),
    );
  }
}