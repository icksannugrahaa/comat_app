// My Package
import 'package:comat_apps/models/user.dart';
import 'package:comat_apps/routes.dart';
import 'package:comat_apps/services/auth.dart';
import 'package:comat_apps/ui/custom_widget/my_splashscreen.dart';
import 'package:comat_apps/ui/constant.dart';

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
  final MyRoutes myRoutes = MyRoutes();
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
        routes: myRoutes.routes,
      ),
    );
  }
}