import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comat App"),
      ),
      body: Container(
        child: Center(
          child: SpinKitCubeGrid(
            color: Colors.blue[400],
            size: 50,
          ),
        ),
      ),
    );
  }
}