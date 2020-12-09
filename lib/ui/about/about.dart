import 'package:flutter/material.dart';
class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
      ),
      body: Center(
        child: Column(
          children: [
            Image.asset("assets/images/under_construction.png"),
            SizedBox(height: 20,),
            Text("Under Development", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),)
          ],
        )
      ),
    );
  }
}