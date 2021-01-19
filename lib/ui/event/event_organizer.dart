// System
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comat_apps/databases/db_event_committee.dart';
import 'package:comat_apps/databases/db_users.dart';
import 'package:comat_apps/models/event_committee.dart';
import 'package:comat_apps/models/user_detail.dart';
import 'package:comat_apps/ui/custom_widget/my_input.dart';
import 'package:comat_apps/ui/custom_widget/my_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// My Package
import 'package:comat_apps/databases/db_events.dart';
import 'package:comat_apps/models/event.dart';
import 'package:comat_apps/models/user.dart';
import 'package:comat_apps/ui/custom_widget/my_appbar.dart';
import 'package:comat_apps/ui/event/event_list.dart';
import 'package:comat_apps/ui/constant.dart';

class EventOrganizer extends StatefulWidget {
  final Event eventData;
  final Function setSelectedEvent;
  final Function setSelectedPage;
  EventOrganizer({this.setSelectedEvent, this.setSelectedPage, this.eventData});

  @override
  _EventOrganizerState createState() => _EventOrganizerState();
}

class _EventOrganizerState extends State<EventOrganizer> {
  String key = '';
  String where = '';
  dynamic value = '';

  @override
  void initState() {
    super.initState();
  }

  void _setSearch(String _key, String _where, dynamic _value) {
    setState(() {
      key = _key;
      where = _where;
      value = _value;
    });
    print(_value);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamProvider<List<EventCommittee>>.value(
      value: DatabaseServiceEventCommittee().allEvent(),
      child: BuildBody(
        widget: widget,
        keys: key,
        user: user,
        value: value,
        where: where,
        fun: _setSearch,
      ),
    );
  }
}

class BuildBody extends StatelessWidget {
  const BuildBody({
    Key key,
    this.keys,
    this.value,
    this.where,
    this.user,
    this.fun,
    @required this.widget,
  }) : super(key: key);

  final EventOrganizer widget;
  final String keys;
  final String where;
  final dynamic value;
  final User user;
  final Function fun;

  void _showJoinForm(context, TextEditingController controller, User u) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return StreamBuilder<UserDetail>(
              stream: DatabaseServiceUsers(uid: user.uid).userData,
              builder: (context, snapshot) {
                UserDetail userDetail = snapshot.data;
                return userDetail == null
                    ? Center(child: CircularProgressIndicator())
                    : SafeArea(
                        child: Container(
                            child: Padding(
                        padding: const EdgeInsets.all(25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Bagikan melalui",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            NormalInput(
                              controller: controller,
                              hint: "xxxx-xxxx",
                              label: "Kode Event",
                              enable: true,
                              isPassword: false,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RaisedButton(
                                  onPressed: () async {
                                    if (controller.text != "") {
                                      print(userDetail.name);
                                      QuerySnapshot variable =
                                          await FirebaseFirestore.instance
                                              .collection('events')
                                              .where('committeeCode',
                                                  isEqualTo: controller.text)
                                              .get();

                                      List<dynamic> _oldCommittee =
                                          variable.docs.first.get('committee');
                                      List<dynamic> _user = [
                                        userDetail.uid,
                                        userDetail.name,
                                        userDetail.email,
                                        userDetail.avatar,
                                        userDetail.phone.toString(),
                                      ];
                                      List<dynamic> _newCommitee =
                                          List<dynamic>();
                                      if (_oldCommittee.length != 0) {
                                        _newCommitee.addAll(_oldCommittee);

                                        _oldCommittee.forEach((value) {
                                          if (value != user.uid) {
                                            _newCommitee.add(user.uid);
                                          }
                                        });
                                      } else {
                                        _newCommitee.add(user.uid.toString());
                                      }
                                      Map<String, dynamic> _event = {
                                        "userCreated": variable.docs.first
                                            .get('userCreated'),
                                        "committeeCode": variable.docs.first
                                            .get('committeeCode'),
                                        "date": variable.docs.first.get('date'),
                                        "description": variable.docs.first
                                            .get('description'),
                                        "image":
                                            variable.docs.first.get('image'),
                                        "limit":
                                            variable.docs.first.get('limit'),
                                        "obtained":
                                            variable.docs.first.get('obtained'),
                                        "organizer": variable.docs.first
                                            .get('organizer'),
                                        "place":
                                            variable.docs.first.get('place'),
                                        "price":
                                            variable.docs.first.get('price'),
                                        "remains":
                                            variable.docs.first.get('remains'),
                                        "rundown":
                                            variable.docs.first.get('rundown'),
                                        "status":
                                            variable.docs.first.get('status'),
                                        "time_end":
                                            variable.docs.first.get('time_end'),
                                        "time_start": variable.docs.first
                                            .get('time_start'),
                                        "title":
                                            variable.docs.first.get('title'),
                                        "category":
                                            variable.docs.first.get('category'),
                                        "keywords":
                                            variable.docs.first.get('keywords'),
                                        "share_url": variable.docs.first
                                            .get('share_url'),
                                        "committee": _newCommitee
                                      };

                                      Map<String, dynamic> _committee = {
                                        "committeeCode": controller.text,
                                        "userData": _user,
                                        "level": "Panitia"
                                      };

                                      await DatabaseServiceEvents().eventUpdate(
                                          variable.docs.first.id, _event);
                                      await DatabaseServiceEventCommittee()
                                          .eventCommitteeCreate(_committee);
                                      myToast(
                                          "Anda berhasil mendaftar sebagai panitia !",
                                          Colors.red);
                                      Navigator.pop(context);
                                    } else {
                                      myToast(
                                          "Tolong input kode !", Colors.red);
                                    }
                                  },
                                  color: Colors.blue[400],
                                  padding: EdgeInsets.symmetric(horizontal: 30),
                                  child: Text(
                                    "Selesai",
                                    style: TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 2.2,
                                        color: Colors.white),
                                  ),
                                ),
                                OutlineButton(
                                  padding: EdgeInsets.symmetric(horizontal: 30),
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    "Batalkan",
                                    style: TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 2.2,
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )));
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    final _event = Provider.of<List<EventCommittee>>(context);
    final TextEditingController code = TextEditingController();
    var committeeCode = '';
    if (_event != null) {
      _event.forEach((element) {
        if (element.userData[0] == user.uid) {
          committeeCode = element.committeeCode;
        }
      });
    }
    return StreamProvider<List<Event>>.value(
        value: committeeCode != ''
            ? DatabaseServiceEvents().events('committee', 'isLike', user.uid)
            : DatabaseServiceEvents().myEvents(keys, where, value, user.uid),
        child: Scaffold(
          appBar: MyAppBar(
            isSearchAble: true,
            setSearch: fun,
          ),
          body: ListView(
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Daftar Event Saya",
                            style: kTitleTextStyle,
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    InkWell(
                        onTap: () => _showJoinForm(context, code, user),
                        child: Text(
                          "Gabung event",
                          style: TextStyle(
                              fontSize: 16,
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w600),
                        )),
                  ],
                ),
              ),
              EventList(
                limit: 10,
                isManage: true,
                setSelectedEvent: widget.setSelectedEvent,
                setSelectedPage: widget.setSelectedPage,
              ),
            ],
          ),
        ));
    // return Container();
  }
}
