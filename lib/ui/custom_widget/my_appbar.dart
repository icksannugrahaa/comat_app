// System
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// My Package
import 'package:comat_apps/databases/db_events.dart';
import 'package:comat_apps/models/event.dart';
import 'package:comat_apps/ui/event/event_list.dart';
import 'package:comat_apps/ui/constant.dart';
import 'package:comat_apps/ui/custom_widget/my_shape.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  MyAppBar({Key key, this.isSearchAble, this.setSearch}) : preferredSize = Size.fromHeight(kToolbarHeight), super(key: key);

  @override
  final Size preferredSize;
  final bool isSearchAble;
  final Function setSearch;

  @override
  _MyAppBarState createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  List<Widget> actionList = List<Widget>();
  List<Event> events = List<Event>();
  @override
  initState() {
    super.initState();
    if(widget.isSearchAble) {
      actionList.add(
        IconButton(
          icon: Icon(Icons.search), 
          onPressed: () {
            showSearch(context: context, delegate: SearchData(eventList: events, setSearch: widget.setSearch));
          }, 
          color: Colors.black,
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if(widget.isSearchAble) {
      events = Provider.of<List<Event>>(context);
    }
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 1,
      actions: actionList,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.keyboard_backspace,
          color: Colors.black,
        ),
      ),
    );
  }
}

class SearchData extends SearchDelegate<String> {
  
  final List<Event> eventList;
  final Function setSearch;
  SearchData({this.eventList, this.setSearch});

  Padding buildCategory(Color colorStart, Color colorEnd,String title, String _key, String _where, dynamic _value) {
    return Padding(
      padding: EdgeInsets.only(top: 15, right: 15, left: 15),
      child: Stack(
        children: [
          Stack(
            children: [
              Container(
                height: 50,
                width: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  gradient: LinearGradient(
                    colors: [
                      colorStart, colorEnd
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorStart,
                      blurRadius: 12,
                      offset: Offset(0,1)
                    )
                  ]
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: InkWell(
                    onTap: () {
                    },
                    highlightColor: colorStart,
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                top: 0,
                child: CustomPaint(
                  painter: CustomCardShapePainter(radius: 15, startColor: colorStart, endColor: colorEnd),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15, left: 10),
                    child: Text(
                      title, 
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {

    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }
  
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        setSearch("", "","");
        close(context, null);
      },
    );
  }
  
  @override
  Widget buildResults(BuildContext context) {
    return StreamProvider<List<Event>>.value(
      value: DatabaseServiceEvents().events("keywords","isLike",query),
      child: Scaffold(
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Cari Event",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              height: 80.0,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                primary: false,
                itemCount: category == null ? 0.0 : category.length,
                itemBuilder: (BuildContext context, int i) {
                  return buildCategory(category[i]['colorStart'],category[i]['colorEnd'], category[i]['title'], category[i]['key'], category[i]['where'], category[i]['value']);
                },
              ),
            ),
            EventList(limit: 10,),
          ],
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    final recentList = query.isEmpty 
      ? eventList 
      : eventList.where((s) => s.title.startsWith(query)).toList();

    return recentList == null 
    ? Center(child: CircularProgressIndicator()) 
    : ListView.builder(
      itemCount: recentList.length,
      itemBuilder: (context, i) {
        if(i < 4) {
          return ListTile(
            onTap: () {
              query = recentList[i].title;
              showResults(context);
            },
            leading: Icon(Icons.access_time),
            title: RichText(
              text: TextSpan(
                text: recentList[i].title.substring(0, query.length),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold
                ),
                children: [
                  TextSpan(
                    text: recentList[i].title.substring(query.length),
                    style: TextStyle(
                      color: Colors.grey
                    )
                  )
                ]
              ),
            ),
          );
        } else {
          return Container();
        }
      }
    );
  } 
}