// My Package
import 'package:comat_apps/databases/db_event_committee.dart';
import 'package:comat_apps/models/user_detail.dart';
import 'package:comat_apps/services/upload_file.dart';
import 'package:comat_apps/ui/custom_widget/my_alert_dialog.dart';
import 'package:comat_apps/ui/custom_widget/my_toast.dart';
import 'package:comat_apps/databases/db_events.dart';
import 'package:comat_apps/models/event.dart';
import 'package:comat_apps/ui/event/event_argument.dart';
import 'package:comat_apps/ui/event/event_detail.dart';
import 'package:comat_apps/ui/constant.dart';
import 'package:comat_apps/ui/event/event_detail_management.dart';

// System
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:indonesia/indonesia.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class EventList extends StatefulWidget {
  final int limit;
  final bool isManage;
  final Function setSelectedEvent;
  final Function setSelectedPage;
  EventList(
      {this.limit, this.isManage, this.setSelectedEvent, this.setSelectedPage});

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  @override
  Widget build(BuildContext context) {
    final events = Provider.of<List<Event>>(context);
    print(events != null ? events.length : 'kosong');
    if (events == null) {
      return Container(
        padding: EdgeInsets.only(top: 70),
        child: Center(
          child: Text(
            "Tidak ada event yang tersedia :(",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
        ),
      );
    } else {
      if (widget.isManage == true) {
        return EventTiles(
            setSelectedEvent: widget.setSelectedEvent,
            setSelectedPage: widget.setSelectedPage);
      } else {
        return events == null || events.length < 1
            ? Container(
                padding: EdgeInsets.only(top: 70),
                child: Center(
                  child: Text(
                    "Tidak ada event yang tersedia :(",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                ),
              )
            : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: events.length ?? 1,
                itemBuilder: (context, index) {
                  return index < widget.limit
                      ? Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: EventTile(
                            event: events[index],
                            isAdmin: false,
                          ),
                        )
                      : Container();
                },
              );
      }
    }
  }
}

class EventTiles extends StatefulWidget {
  final Function setSelectedEvent;
  final Function setSelectedPage;
  EventTiles({this.setSelectedEvent, this.setSelectedPage});

  @override
  _EventTilesState createState() => _EventTilesState();
}

class _EventTilesState extends State<EventTiles> {
  SlidableController slidableController;
  UploadService _uploadService = UploadService();

  @protected
  void initState() {
    slidableController = SlidableController(
      onSlideAnimationChanged: handleSlideAnimationChanged,
      onSlideIsOpenChanged: handleSlideIsOpenChanged,
    );
    super.initState();
  }

  Animation<double> _rotationAnimation;
  Color _fabColor = Colors.blue;

  void handleSlideAnimationChanged(Animation<double> slideAnimation) {
    setState(() {
      _rotationAnimation = slideAnimation;
    });
  }

  void handleSlideIsOpenChanged(bool isOpen) {
    setState(() {
      _fabColor = isOpen ? Colors.green : Colors.blue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildList(context);
  }

  Widget _buildList(BuildContext context) {
    final events = Provider.of<List<Event>>(context);
    return events.isEmpty
        ? Center(
            child: Container(
              child: Text(
                "Ayo buat event :)",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: events.length ?? 1,
            itemBuilder: (context, index) {
              final Axis slidableDirection = Axis.horizontal;
              return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: _getSlidableWithLists(
                      context, index, slidableDirection, events[index]));
            },
          );
  }

  Widget _getSlidableWithLists(
      BuildContext context, int index, Axis direction, Event item) {
    _func(UserDetail us, bool isTrue) async {
      if (isTrue) {
        await DatabaseServiceEvents(eid: item.eid).eventDelete(item.eid);
        await DatabaseServiceEventCommittee()
            .eventCommitteeDelete(item.committeeCode);
        await _uploadService.deleteImageFromFirebase(item.image);
      }
    }

    return Slidable(
      closeOnScroll: true,
      key: Key(item.title),
      controller: slidableController,
      direction: direction,
      actionPane: SlidableBehindActionPane(),
      actionExtentRatio: 0.25,
      child: VerticalListItem(item),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Bagikan kode',
          color: Colors.blue,
          icon: Icons.share,
          onTap: () => myToast(
              "Fitur masih dalam tahap pengembangan", Colors.green[400]),
        ),
        IconSlideAction(
          caption: 'Bagikan url',
          color: Colors.indigo,
          icon: Icons.share,
          onTap: () => myToast(
              "Fitur masih dalam tahap pengembangan", Colors.green[400]),
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Selesai',
          color: Colors.green[400],
          icon: Icons.check,
          onTap: () {
            widget.setSelectedEvent(item);
            widget.setSelectedPage(1);
          },
          closeOnTap: false,
        ),
        IconSlideAction(
          caption: 'Ubah',
          color: Colors.grey.shade200,
          icon: Icons.edit,
          onTap: () {
            widget.setSelectedEvent(item);
            widget.setSelectedPage(1);
          },
          closeOnTap: false,
        ),
        IconSlideAction(
          caption: 'Hapus',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () async {
            myAlertDialog(
                context,
                "Apakah anda yakin akan menghapus Event ini ?\nTekan 'Lanjutkan' untuk menyetujui.",
                null,
                _func,
                "Event berhasil dihapus !",
                Colors.green,
                null);
          },
        ),
      ],
    );
  }
}

class HorizontalListItem extends StatelessWidget {
  HorizontalListItem(this.item);
  final Event item;
  @override
  Widget build(BuildContext context) {
    return EventTile(
      event: item,
      isAdmin: true,
    );
  }
}

class VerticalListItem extends StatelessWidget {
  VerticalListItem(this.item);
  final Event item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Slidable.of(context)?.renderingMode == SlidableRenderingMode.none
              ? Slidable.of(context)?.open()
              : Slidable.of(context)?.close(),
      child: EventTile(
        event: item,
        isAdmin: true,
      ),
    );
  }
}

class EventTile extends StatelessWidget {
  final Event event;
  final bool isAdmin;
  const EventTile({Key key, this.isAdmin, this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final date = DateTime.fromMillisecondsSinceEpoch(
        int.parse(event.timeStart.substring(18, 28)) * 1000);
    final date2 = DateTime.now();
    final difference = date.difference(date2).inDays;
    final percentace = (event.remains * 100) / event.limit;
    return Stack(
      children: [
        Stack(
          children: [
            Container(
              height: 136,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  gradient: LinearGradient(
                      colors: [Colors.white, Colors.white],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 12,
                        offset: Offset(0, 1))
                  ]),
              child: Material(
                borderRadius: BorderRadius.circular(borderRadius),
                child: InkWell(
                  onTap: () => isAdmin
                      ? Navigator.pushNamed(
                          context,
                          EventDetailManagement.routeName,
                          arguments: EventArguments(event),
                        )
                      : Navigator.pushNamed(
                          context,
                          EventDetail.routeName,
                          arguments: EventArguments(event),
                        ),
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
            )
          ],
        ),
        ClipRect(
          child: Banner(
            message: "${event.remains} slot",
            location: BannerLocation.topEnd,
            textStyle: TextStyle(fontSize: 10),
            color: percentace >= 70
                ? Colors.green
                : percentace >= 30
                    ? Colors.orange[300]
                    : Colors.red,
            child: Row(
              children: [
                Image.network(
                  event.image,
                  height: 120,
                  width: 130,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  height: 136,
                  width: MediaQuery.of(context).size.width - 170,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(event.title,
                          style: kTitleTextStyle.copyWith(fontSize: 16),
                          overflow: TextOverflow.ellipsis),
                      Flexible(
                        child: Text(event.description,
                            style: TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis),
                      ),
                      Row(
                        children: [
                          Chip(
                            avatar: CircleAvatar(
                              backgroundColor: difference >= 7
                                  ? Colors.green
                                  : difference >= 5
                                      ? Colors.orange[300]
                                      : Colors.red,
                              child: Icon(
                                Icons.access_time,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                            label: Text(
                              tanggal(date),
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
