import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children : [
            SpinKitCircle(
              color: Colors.blue[400],
              size: 60.0,
            ),
          ]
        )
      ),
    );
  }
}