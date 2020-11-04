import 'package:comat_apps/ui/Home.dart';
import 'package:comat_apps/ui/wrapper.dart';
import 'package:flutter/material.dart';

void main() => runApp( MainApp() );

class MainApp extends StatelessWidget {
  final title = "Comat App";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      // home: Home(title: title),
      home: Wrapper(),
    );
  }
}