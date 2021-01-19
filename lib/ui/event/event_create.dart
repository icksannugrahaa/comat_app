// System
import 'dart:io';
import 'package:comat_apps/databases/db_users.dart';
import 'package:comat_apps/models/user_detail.dart';
import 'package:comat_apps/services/dynamic_link.dart';
import 'package:comat_apps/ui/custom_widget/my_appbar.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

// My Package
import 'package:comat_apps/databases/db_event_committee.dart';
import 'package:comat_apps/models/event.dart';
import 'package:comat_apps/models/user.dart';
import 'package:comat_apps/databases/db_events.dart';
import 'package:comat_apps/services/upload_file.dart';
import 'package:comat_apps/helpers/my_helpers.dart';
import 'package:comat_apps/ui/custom_widget/my_input.dart';
import 'package:comat_apps/ui/custom_widget/my_loading.dart';
import 'package:comat_apps/ui/custom_widget/my_imagepicker.dart';
import 'package:comat_apps/ui/custom_widget/my_toast.dart';

// Other
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EventCreate extends StatefulWidget {
  final Event myEvent;
  final Function setSelectedPage;
  EventCreate({this.myEvent, this.setSelectedPage});
  
  @override
  _EventCreateState createState() => _EventCreateState();
}

class _EventCreateState extends State<EventCreate> {
  bool loading = false;
  String _dateStart = "Pilih tanggal";
  String _timeStart = "Pilih waktu";
  String _dateEnd = "Pilih tanggal";
  String _timeEnd = "Pilih waktu";
  String _oldDate = "";
  String _oldTime = "";
  String category = 'Workshop';
  String committeeCode;
  String pageTitle = 'Buat Event Baru';
  String _imageN;
  String formType;
  String eid;
  String _oldUid;
  List<String> options = <String>['Workshop', 'Seminar', 'Webinar', 'Festival', 'Music', 'Social Activity', 'Online Discussion'];
  List<dynamic> _oldCommittee = List<dynamic>();

  UploadService _uploadService = UploadService();
  MyHelpers _helpers = MyHelpers();
  File _imageF;
  DynamicLinkService _linkService = DynamicLinkService();

  // error 
  String _errorImage = " ";
  String _errorDateStart = " ";
  String _errorDateEnd = " ";

  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  // Text controller
  final TextEditingController title = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController rundown = TextEditingController();
  final TextEditingController obtained = TextEditingController();
  final TextEditingController organizer = TextEditingController();
  final TextEditingController place = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController stock = TextEditingController();
  final TextEditingController code = TextEditingController();

  @override
  void initState() {
    super.initState();
    if(widget.myEvent != null) {
      _setForm(widget.myEvent);
    } else {
      _resetForm();
    }
  }
  
  _resetForm() {
    setState(() {
      formType = "insert";
      _dateStart = "Pilih tanggal";
      _timeStart = "Pilih waktu";
      _dateEnd = "Pilih tanggal";
      _timeEnd = "Pilih waktu";
      category = 'Workshop';
      pageTitle = "Buat Event Baru";
      title.text = "";
      description.text = "";
      obtained.text = "";
      organizer.text = "";
      place.text = "";
      rundown.text = "";
      price.text = "0";
      stock.text = "0";
      code.text = "${_helpers.getRandomString(4)}-${_helpers.getNumberString(4)}";
      _imageF = null;
      _imageN = null;
      eid = null;

      _oldCommittee != null ? _oldCommittee.clear() : _oldCommittee = null;
    });
  }

  _setForm(Event e) {
    setState(() {
      formType = "update";
      final dateStart = DateTime.fromMillisecondsSinceEpoch(int.parse(e.timeStart.substring(18, 28)) * 1000);
      final dateEnd = DateTime.fromMillisecondsSinceEpoch(int.parse(e.timeEnd.substring(18, 28)) * 1000);
      final timestart = DateFormat('Hms').format(dateStart);
      final timeend = DateFormat('Hms').format(dateEnd);
      final oldDate = DateTime.fromMillisecondsSinceEpoch(int.parse(e.date.substring(18, 28)) * 1000);
      _dateStart = dateStart.toString().substring(0, 10);
      _timeStart = timestart;
      _dateEnd = dateEnd.toString().substring(0, 10);
      _timeEnd = timeend;
      _oldDate = oldDate.toString().substring(0, 10);
      _oldTime = DateFormat('Hms').format(oldDate);
      category = e.category;
      pageTitle = "Ubah Data Event";
      title.text = e.title;
      description.text = e.description;
      obtained.text = e.obtained;
      organizer.text = e.organizer;
      place.text = e.place;
      rundown.text = e.rundown;
      price.text = e.price.toString();
      stock.text = e.limit.toString();
      code.text = e.committeeCode;
      _imageF = null;
      _imageN = e.image;
      eid = e.eid;
      _oldUid = e.userCreated;
      _oldCommittee.addAll(e.committee);
    });
  }

  setImageState(PickedFile _pickedFile) {
    setState(() {
      if (_pickedFile != null) {
        _imageF = File(_pickedFile.path);
      } else {
        _errorImage = "Tidak ada gambar yang dipilih !";
      }
    });
  }

  setDateTimeState(String date, String time, bool state) {
    if(state) {
      setState(() {
        _dateStart = date;
        _timeStart = time;
      });
    } else {
      setState(() {
        _dateEnd = date;
        _timeEnd = time;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return loading ? Loading() : Scaffold(
      appBar: MyAppBar(isSearchAble: false,),
      body: StreamBuilder<UserDetail>(
      stream: DatabaseServiceUsers(uid: user.uid).userData,
        builder: (context, snapshot) {
          UserDetail userDetail = snapshot.data;
          // print(userDetail != null ? userDetail.name : userDetail!=null);
          return userDetail == null ? Center(child: CircularProgressIndicator()) :  GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Text(
                          pageTitle,
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      MyImagePicker(imageF: _imageF, errorImage: _errorImage, picker: picker, imageN: _imageN, setImageState: setImageState, isProfile: false,),
                      SizedBox(height: 10,),
                      Center(
                        child: Text(
                          _errorImage,
                          style: TextStyle(
                            color: Colors.red
                          ),
                        )
                      ),
                      SizedBox(height: 20,),
                      NormalInput(isPassword: false,label: "Judul",hint: "contoh: Hackaton, Drama Music ...",inputType: TextInputType.text,controller: title),
                      SizedBox(height: 20,),
                      NormalInput(isPassword: false,label: "Deskripsi",hint: "contoh: Event ini diselengarakan ...",inputType: TextInputType.multiline,controller: description),
                      SizedBox(height: 20,),
                      NormalInput(isPassword: false,label: "Banefit",hint: "contoh: Sertifikat, Ilmu yang bermanfaat ...",inputType: TextInputType.multiline,controller: obtained),
                      SizedBox(height: 20,),
                      NormalInput(isPassword: false,label: "Penyelenggara",hint: "contoh: Universitas, Prodi ...",inputType: TextInputType.text,controller: organizer),
                      SizedBox(height: 20,),
                      NormalInput(isPassword: false,label: "Alamat/Tempat",hint: "contoh: Bandung ..., Youtube (jika online), ...",inputType: TextInputType.text,controller: place),
                      SizedBox(height: 20,),
                      NormalInput(isPassword: false,label: "Harga",hint: "10000",inputType: TextInputType.number,controller: price),
                      SizedBox(height: 20,),
                      NormalInput(isPassword: false,label: "Jumlah Tiket",hint: "100",inputType: TextInputType.number,controller: stock),
                      SizedBox(height: 20,),
                      NormalInput(isPassword: false,label: "Penjadwalan",hint: "Rundowns : \n 1. Scan Qr \n 2. Mencari tempat duduk ...",inputType: TextInputType.multiline,controller: rundown),
                      SizedBox(height: 20,),              
                      DropdownButton<String>(
                        value: category,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        onChanged: (String newValue) {
                          setState(() {
                            category = newValue;
                          });
                        },
                        items: options.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 20,),
                      MyDatePicker(dates: _dateStart, times: _timeStart, text: "Waktu mulai", setDateTimeState: setDateTimeState, states: true,),
                      SizedBox(height: 10,),
                      Center(
                        child: Text(
                          _errorDateStart,
                          style: TextStyle(
                            color: Colors.red
                          ),
                        )
                      ),
                      SizedBox(height: 20,),
                      MyDatePicker(dates: _dateEnd, times: _timeEnd, text: "Waktu selesai", setDateTimeState: setDateTimeState, states: false,),
                      SizedBox(height: 10,),
                      Center(
                        child: Text(
                          _errorDateEnd,
                          style: TextStyle(
                            color: Colors.red
                          ),
                        )
                      ),
                      SizedBox(height: 20,),
                      NormalInput(isPassword: false, label: "Kode penyelenggara", inputType: TextInputType.text, controller: code, enable: false,),
                      SizedBox(height: 20,),
                      Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RaisedButton(
                                onPressed: () async {
                                  setState(() => loading = true );
                                  if(_formKey.currentState.validate()) {
                                    if(_imageF == null && _imageN.isEmpty) {
                                      setState(() {
                                        _errorImage = "Tolong pilih gambar !";
                                      });
                                      myToast("Tolong isi semua form masukan !", Colors.red);
                                    } else if(_dateStart.contains("Pilih") || _timeStart.contains("Pilih")) {
                                      setState(() {
                                        _errorImage = " ";
                                        _errorDateStart = "Tolong pilih waktu";
                                        _errorDateEnd = " ";
                                      });
                                      myToast("Tolong isi semua form masukan !", Colors.red);
                                    } else if(_dateEnd.contains("Pilih") || _timeEnd.contains("Pilih")) {
                                        setState(() {
                                        _errorImage = " ";
                                        _errorDateStart = " ";
                                        _errorDateEnd = "Tolong pilih waktu";
                                      });
                                      myToast("Tolong isi semua form masukan !", Colors.red);
                                    } else {
                                      dynamic _url = "";
                                      if(_imageF != null) {
                                        if(formType == "insert") {
                                          _url = await _uploadService.uploadImageToFirebase(context, _imageF, "/uploads/images/events");
                                        } else {
                                          await _uploadService.deleteImageFromFirebase(_imageN);
                                          _url = await _uploadService.uploadImageToFirebase(context, _imageF, "/uploads/images/events");
                                        }
                                      } else { 
                                        _url = _imageN;
                                      } 
                                      List<String> keywords = _helpers.makeKeywords(title.text, category, place.text);
                                      var _shareUrl = await _linkService.createEventShareLink(title.text);

                                      List<dynamic> _user = [
                                        userDetail.uid,
                                        userDetail.name,
                                        userDetail.email,
                                        userDetail.avatar,
                                        userDetail.phone.toString(),
                                      ];

                                      List<dynamic> _newCommitee = List<dynamic>();
                                      if(_oldCommittee.length != 0) {
                                        _newCommitee.addAll(_oldCommittee);

                                        _oldCommittee.forEach((value) {
                                          if(value != user.uid) {
                                            _newCommitee.add(user.uid);
                                          }
                                        });
                                      } else {
                                        _newCommitee.add(user.uid.toString());
                                      }

                                      Map<String, dynamic> _event = {
                                        "userCreated": formType.contains("insert") ? user.uid : _oldUid,
                                        "committeeCode": code.text,
                                        "date": formType.contains("insert") ? DateTime.now() : _helpers.convertDateFromString("$_oldDate $_oldTime"),
                                        "description": description.text,
                                        "image": _url,
                                        "limit": int.parse(stock.text),
                                        "obtained": obtained.text,
                                        "organizer": organizer.text,
                                        "place": place.text,
                                        "price": int.parse(price.text),
                                        "remains": int.parse(stock.text),
                                        "rundown": rundown.text,
                                        "status": true,
                                        "time_end": _helpers.convertDateFromString("$_dateEnd $_timeEnd"),
                                        "time_start": _helpers.convertDateFromString("$_dateStart $_timeStart"),
                                        "title": title.text,
                                        "category": category,
                                        "keywords": keywords,
                                        "share_url": _shareUrl,
                                        "committee": _newCommitee
                                      };
                                      
                                      Map<String, dynamic> _committee = {
                                        "committeeCode": code.text,
                                        "userData": _user,
                                        "level": "Creator"
                                      };

                                      if(formType == "insert") {
                                        await DatabaseServiceEvents().eventCreate(_event);
                                        await DatabaseServiceEventCommittee().eventCommitteeCreate(_committee);
                                        myToast("Event berhasil dibuat !", Colors.green[400]);
                                      } else {
                                        await DatabaseServiceEvents().eventUpdate(eid,_event);
                                        myToast("Event berhasil diubah !", Colors.green[400]);
                                      }
                                      widget.setSelectedPage(0);
                                      setState(() => loading = false);
                                    }
                                  } else {
                                      myToast("Tolong isi semua form masukan !", Colors.red);
                                  }
                                  setState(() => loading = false );
                                },
                                color: Colors.blue[400],
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                child: Text(
                                  "Selesai",
                                  style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 2.2,
                                    color: Colors.white
                                  ),
                                ),
                              ),
                              OutlineButton(
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                onPressed: () {
                                  _resetForm();
                                },
                                child: Text(
                                  "Batalkan",
                                  style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 2.2,
                                    color: Colors.black
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
class MyDatePicker extends StatelessWidget {
  
  final String dates;
  final String times;
  final String text;
  final bool states;
  final Function setDateTimeState;
  MyDatePicker({this.dates, this.text, this.times, this.setDateTimeState, this.states});

  @override
  Widget build(BuildContext context) {
    String _time = times.contains("Pilih") ? "Pilih waktu" : times;
    String _date = dates.contains("Pilih") ? "Pilih tanggal" : dates;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("$text :"),
        RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0)
          ),
          elevation: 4.0,
          onPressed: () {
            DatePicker.showDatePicker(context,
              theme: DatePickerTheme(
                containerHeight: 210.0,
              ),
              showTitleActions: true,
              minTime: DateTime.now(),
              maxTime: DateTime(2030, 12, 31), onConfirm: (date) {
                _date = '${date.year}-${date.month}-${date.day}';
                setDateTimeState(_date, _time, states);
              }, currentTime: DateTime.now(), locale: LocaleType.id);
          },
          child: Container(
            alignment: Alignment.center,
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Icon(
                            Icons.date_range,
                            size: 14.0,
                          ),
                          Text(
                            " $dates",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,    
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          color: Colors.white,
        ),
        RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0)),
          elevation: 4.0,
          onPressed: () {
            DatePicker.showTimePicker(context,
                theme: DatePickerTheme(
                  containerHeight: 210.0,
                ),
                showTitleActions: true, onConfirm: (time) {
              _time = '${time.hour}:${time.minute}:${time.second}';
              setDateTimeState(_date, _time, states);
            }, currentTime: DateTime.now(), locale: LocaleType.en);
            
          },
          child: Container(
            alignment: Alignment.center,
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.access_time,
                          ),
                          Text(
                            " $times",
                            style: TextStyle(
                              fontWeight: FontWeight.w500
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          color: Colors.white,
        ),
      ],
    );
  }
}