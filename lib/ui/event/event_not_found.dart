import 'package:comat_apps/ui/custom_widget/my_appbar.dart';
import 'package:flutter/material.dart';

class EventNotFound extends StatefulWidget {
  @override
  _EventNotFoundState createState() => _EventNotFoundState();
}

class _EventNotFoundState extends State<EventNotFound> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        isSearchAble: false,
      ),
      body: Container(
          child: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16, top: 25, right: 16),
            child: Column(
              children: [
                Image.asset("assets/images/under_construction.png"),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: Text(
                    "Event tidak ditemukan :(",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                  child: Text(
                    "Silahkan cari event lainnya :)",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/event-search');
                  },
                  color: Colors.blue[400],
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "Cari event",
                    style: TextStyle(
                        fontSize: 14, letterSpacing: 2.2, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
