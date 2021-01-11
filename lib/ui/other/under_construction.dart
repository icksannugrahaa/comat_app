import 'package:comat_apps/ui/custom_widget/my_appbar.dart';
import 'package:flutter/material.dart';

class UnderConstruction extends StatefulWidget {
  @override
  _UnderConstructionState createState() => _UnderConstructionState();
}

class _UnderConstructionState extends State<UnderConstruction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(isSearchAble: false,),
      body: Container(
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16, top: 25, right: 16),
              child: Column(
                children: [
                  Image.asset("assets/images/under_construction.png"),
                  SizedBox(height: 30,),
                  Center(
                    child: Text(
                      "Dalam tahap pembangunan",
                      style: TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}