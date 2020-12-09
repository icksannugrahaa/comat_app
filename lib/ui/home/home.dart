import 'package:comat_apps/databases/db_events.dart';
import 'package:comat_apps/models/event.dart';
import 'package:comat_apps/ui/constant.dart';
import 'package:comat_apps/ui/event/event_list.dart';
import 'package:comat_apps/ui/layout/header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  Home({Key key, this.title, this.drawer, this.splashscreen}) : super(key: key);
  final String title;
  final Widget drawer;
  final bool splashscreen;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Event>>.value(
      value: DatabaseServiceEvents().events,
      child: Scaffold(
          key: _scaffoldKey,
          body: HomeBody(scaffoldKey: _scaffoldKey,),
          drawer: drawer,
          // floatingActionButton: FancyFab(icon: Icons.add, tooltip: 'Open Menu',),
      ),
    );
  }
}

class HomeBody extends StatelessWidget {
  final scaffoldKey;
  const HomeBody({
    this.scaffoldKey
  });

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<User>(context);
    var menu = [
      {"image": "assets/images/events.png", "title": "Search Event", "route": "/under-construction"},
      {"image": "assets/images/newevent.png", "title": "Make Your Event", "route": "/under-construction"},
      {"image": "assets/images/history.png", "title": "History Event", "route": "/under-construction"},
    ];
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 145,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  primary: false,
                  itemCount: menu == null ? 0.0 : menu.length,
                  itemBuilder: (BuildContext context, int i) {
                    return FeatureList(image: menu[i]['image'], title: menu[i]['title'], route: menu[i]['route'],);
                  },
                ),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Event Update",
                            style: kTitleTextStyle,
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Text("See More", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w600),),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: EventList(),
              )
            ],
          ),
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
      padding: const EdgeInsets.only(right: 10, left: 10),
      child: InkWell( 
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white.withOpacity(0.8),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 10),
                blurRadius: 20,
                color: kActiveShadowColor
              )
            ]
          ),
          child: Column(
            children: [
              Image.asset(image, height: 90, width: 90,),
              Padding(padding: EdgeInsets.only(top: 10),),
              Text(title, style: TextStyle(fontWeight: FontWeight.bold),)
            ],
          ),
        ),
      ),
    );
  }
}
