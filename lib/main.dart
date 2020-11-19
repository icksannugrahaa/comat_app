import 'package:comat_apps/models/user.dart';
import 'package:comat_apps/services/auth.dart';
import 'package:comat_apps/ui/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';
import 'ui/constant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MainApp());
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 5,
      navigateAfterSeconds: new Wrapper(),
      image: new Image.asset(
          'assets/images/cm_logo.png'),
      backgroundColor: Colors.white,
      photoSize: 200,
      loaderColor: Colors.blue[300],

    );
  }
}
class MainApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: kBackgroundColor,
          fontFamily: "Poppins",
          textTheme: TextTheme(
            body1: TextStyle(color: kBodyTextColor)
          )
        ),
        title: titleApp,
        home: Splash(),
      ),
    );
  }
}
