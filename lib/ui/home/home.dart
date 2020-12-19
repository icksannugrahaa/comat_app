import 'package:comat_apps/databases/db_events.dart';
import 'package:comat_apps/models/event.dart';
import 'package:comat_apps/ui/constant.dart';
import 'package:comat_apps/ui/event/event_list.dart';
import 'package:comat_apps/ui/layout/header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  Home({Key key, this.title, this.drawer, this.splashscreen, this.user}) : super(key: key);
  final String title;
  final Widget drawer;
  final bool splashscreen;
  final user;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Event>>.value(
      value: DatabaseServiceEvents().events('','',''),
      child: Scaffold(
          key: _scaffoldKey,
          body: HomeBody(scaffoldKey: _scaffoldKey,user: user,),
          drawer: drawer,
      ),
    );
  }
}

class HomeBody extends StatelessWidget {
  final scaffoldKey;
  final user;
  const HomeBody({
    this.scaffoldKey, this.user
  });

  @override
  Widget build(BuildContext context) {
    var menu = [
      {"image": "assets/images/events.png", "title": "Search Event", "route": "/event-search"},
    ];
    if(user != null) {
      menu.add({"image": "assets/images/newevent.png", "title": "Make Your Event", "route": "/event-manage"});
      menu.add({"image": "assets/images/history.png", "title": "History Event", "route": "/under-construction"});
    }
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Header(
            decorationImg: 'assets/images/bg_transparent.png',
            imageWidth: 300,
            textOrImg: false,
            textSize: 0,
            titleImage: "assets/images/bg_user.png",
            titleText: "",
            icon: Icons.menu,
            online: false,
            scaffoldKey: scaffoldKey,
          ),
          Container(
            height: 180,
            width: double.infinity,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              primary: false,
              itemCount: menu == null ? 0.0 : menu.length,
              itemBuilder: (BuildContext context, int i) {
                return FeatureList(image: menu[i]['image'], title: menu[i]['title'], route: menu[i]['route'],);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "The Closest Time Event",
                        style: kTitleTextStyle,
                      ),
                    ],
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () => Navigator.pushNamed(context, "/event-search"),
                  child: Text("See More", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w600),)
                ),
              ],
            ),
          ),
          EventList(limit: 4,),
        ],
      ),
    );
  }
}

class FeatureList extends StatelessWidget {
  final String title;
  final String image;
  final String route;
  const FeatureList({
    Key key, this.image, this.title, this.route
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Stack(
        children: [
          Stack(
            children: [
              Container(
                height: 140,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white, Colors.white
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 12,
                      offset: Offset(0,1)
                    )
                  ]
                ),
                child: Material(
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: InkWell(
                    onTap: () => Navigator.pushNamed(context, route),
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15,left: 15, bottom:15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(image, height: 90, width: 90,),
                Padding(padding: EdgeInsets.only(top: 15),),
                Text(title, style: TextStyle(fontWeight: FontWeight.bold),)
              ],
            ),
          ),
        ],
      ),
    );
  }
}