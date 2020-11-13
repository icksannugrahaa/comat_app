import 'package:comat_apps/models/user.dart';
import 'package:comat_apps/services/auth.dart';
import 'package:comat_apps/ui/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  final title = "Comat App";

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        // home: Home(title: title),
        home: Wrapper(),
      ),
    );
  }
}
