import 'package:comat_apps/models/user.dart';
import 'package:comat_apps/services/auth.dart';
import 'package:comat_apps/ui/about/about.dart';
import 'package:comat_apps/ui/authentication/login.dart';
import 'package:comat_apps/ui/event/event_detail.dart';
import 'package:comat_apps/ui/layout/splashscreen.dart';
import 'package:comat_apps/ui/other/under_construction.dart';
import 'package:comat_apps/ui/setting/password.dart';
import 'package:comat_apps/ui/setting/profile.dart';
import 'package:comat_apps/ui/setting/profile_image.dart';
import 'package:comat_apps/ui/setting/setting.dart';
import 'package:comat_apps/ui/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'ui/constant.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MainApp());
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
        home: SplashScreen(),
        routes: {
          '/home': (context) => Wrapper(),
          '/login': (context) => LoginPage(),
          '/setting': (context) => Setting(),
          '/profile': (context) => SettingProfile(),
          '/change-password': (context) => SettingPassword(),
          '/about': (context) => About(),
          '/under-construction': (context) => UnderConstruction(),
          '/splashscreen': (context) => SplashScreen(),
          '/test': (context) => UploadingImageToFirebaseStorage(),
          EventDetail.routeName: (context) => EventDetail(),
        },
      ),
    );
  }
}