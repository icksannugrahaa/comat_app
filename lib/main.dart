sih// My Package
import 'package:comat_apps/models/user.dart';
import 'package:comat_apps/services/auth.dart';
import 'package:comat_apps/ui/about/about.dart';
import 'package:comat_apps/ui/authentication/login.dart';
import 'package:comat_apps/ui/event/event_create.dart';
import 'package:comat_apps/ui/event/event_detail.dart';
import 'package:comat_apps/ui/event/event_manage.dart';
import 'package:comat_apps/ui/event/event_search.dart';
import 'package:comat_apps/ui/custom_widget/my_splashscreen.dart';
import 'package:comat_apps/ui/other/under_construction.dart';
import 'package:comat_apps/ui/setting/password.dart';
import 'package:comat_apps/ui/setting/profile.dart';
import 'package:comat_apps/ui/setting/setting.dart';
import 'package:comat_apps/ui/wrapper.dart';
-import 'package:comat_apps/ui/constant.dart';

// System
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
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
          textTheme: TextTheme(
            bodyText2: TextStyle(color: kBodyTextColor)
          )
        ),
        title: titleApp,
        home: SplashScreen(),
        routes: {
          '/home': (_) => Wrapper(),
          '/login': (_) => LoginPage(),
          '/setting': (_) => Setting(),
          '/profile': (_) => SettingProfile(),
          '/reset-password': (_) => SettingPassword(),
          '/about': (_) => About(),
          '/under-construction': (_) => UnderConstruction(),
          '/splashscreen': (_) => SplashScreen(),
          '/event-search': (_) => EventSearch(),
          '/event-create': (_) => EventCreate(),
          '/event-manage': (_) => EventManage(),
          // '/test': (context) => UploadingImageToFirebaseStorage(),
          EventDetail.routeName: (_) => EventDetail(),
        },
      ),
    );
  }
}