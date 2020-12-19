import 'dart:io';
import 'package:comat_apps/databases/db_event_committee.dart';
import 'package:comat_apps/models/event.dart';
import 'package:comat_apps/models/user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:comat_apps/databases/db_events.dart';
import 'package:comat_apps/services/upload_file.dart';
import 'package:comat_apps/helpers/my_helpers.dart';
import 'package:comat_apps/ui/custom_widget/my_input.dart';
import 'package:comat_apps/ui/custom_widget/my_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EventCreate extends StatefulWidget {
  final Event myEvent;
  EventCreate({this.myEvent});
  
  @override
  _EventCreateState createState() => _EventCreateState();
}

class _EventCreateState extends State<EventCreate> {
  bool loading = false;
  double _inputHeight = 50;
  String _dateStart = "Not set";
  String _timeStart = "Not set";
  String _dateEnd = "Not set";
  String _timeEnd = "Not set";
  String category = 'Workshop';
  String committeeCode;
  String pageTitle = 'Create New Event';
  List<String> options = <String>['Workshop', 'Seminar', 'Webinar', 'Festival', 'Music', 'Social Activity', 'Online Discussion'];
  UploadService _uploadService = UploadService();
  MyHelpers _helpers = MyHelpers();
  File _image;

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
  TextEditingController code = TextEditingController();

  

  @override
  void initState() {
    super.initState();
    description.addListener(_checkInputHeight);
    if(widget.myEvent != null) {
      pageTitle = "Edit Event";
      title.text = widget.myEvent.title;
      description.text = widget.myEvent.description;
      obtained.text = widget.myEvent.obtained;
      organizer.text = widget.myEvent.organizer;
      place.text = widget.myEvent.place;
      rundown.text = widget.myEvent.rundown;
      price.text = widget.myEvent.price.toString();
      stock.text = widget.myEvent.limit.toString();
      code.text = widget.myEvent.committeeCode;
    } else {
      committeeCode = "${_helpers.getRandomString(4)}-${_helpers.getNumberString(4)}";
      code = TextEditingController(text: committeeCode);
      pageTitle = "Create New Event";
    }
  }

  @override
  void dispose() {
    description.dispose();
    super.dispose();
  }

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
      source: ImageSource.camera, imageQuality: 50
    );

    setState(() {
      _image = image;
    });
    print(_image);
  }

  _imgFromGallery() async {
    File image = await  ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    setState(() {
      _image = image;
    });
    print(_image);
  }


  void _checkInputHeight() async {
    int count = description.text.split('\n').length;

    if (count == 0 && _inputHeight == 50.0) {
      return;
    }
    if (count <= 5) {  // use a maximum height of 6 rows 
    // height values can be adapted based on the font size
      var newHeight = count == 0 ? 50.0 : 28.0 + (count * 18.0);
      setState(() {
        _inputHeight = newHeight;
      });
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text('Photo Library'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  convertDateFromString(String strDate){
    DateTime todayDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(strDate);
    print(todayDate);
    return todayDate;
  }

  _showToast(String text, Color bgcolor) {
    return Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: bgcolor,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return loading ? Loading() : Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // padding: EdgeInsets.all(20),
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
                Center(
                  child: GestureDetector(
                    onTap: () {
                      _showPicker(context);
                    },
                    child: Stack(
                      children: [
                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor
                            ),
                            boxShadow: [
                              BoxShadow(
                                spreadRadius: 2, 
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(0,10)
                              )
                            ],
                          ),
                          child: _image != null
                          ? ClipRRect(
                              // borderRadius: BorderRadius.circular(50),
                              child: Image.file(
                                _image,
                                fit: BoxFit.fitHeight,
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(50)),
                              width: 100,
                              height: 100,
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.grey[800],
                              ),
                            ),
                        ),
                      ],
                    ),
                  ),
                ),
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
                NormalInput(isPassword: false,label: "Title",hint: "Title",inputType: TextInputType.text,controller: title),
                SizedBox(height: 20,),
                NormalInput(isPassword: false,label: "Description",hint: "Description",inputType: TextInputType.multiline,controller: description),
                SizedBox(height: 20,),
                NormalInput(isPassword: false,label: "Obtained",hint: "What will be obtained from the event",inputType: TextInputType.multiline,controller: obtained),
                SizedBox(height: 20,),
                NormalInput(isPassword: false,label: "Organizer",hint: "Organizer",inputType: TextInputType.text,controller: organizer),
                SizedBox(height: 20,),
                NormalInput(isPassword: false,label: "Place",hint: "Place",inputType: TextInputType.text,controller: place),
                SizedBox(height: 20,),
                NormalInput(isPassword: false,label: "Price",hint: "100",inputType: TextInputType.number,controller: price),
                SizedBox(height: 20,),
                NormalInput(isPassword: false,label: "Ticket Total",hint: "100",inputType: TextInputType.number,controller: stock),
                SizedBox(height: 20,),
                NormalInput(isPassword: false,label: "Rundowns",hint: "Rundowns : \n 1. Scan Qr \n 2. Looking for a seat ...",inputType: TextInputType.multiline,controller: rundown),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Time Start :"),
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
                            print('confirm $date');
                            _dateStart = '${date.year}-${date.month}-${date.day}';
                            setState(() {});
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
                                        " $_dateStart",
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
                          print('confirm $time');
                          _timeStart = '${time.hour}:${time.minute}:${time.second}';
                          setState(() {});
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                        setState(() {});
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
                                        " $_timeStart",
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
                ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Time End :"),
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
                            print('confirm $date');
                            _dateEnd = '${date.year}-${date.month}-${date.day}';
                            setState(() {});
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
                                        " $_dateEnd",
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
                          print('confirm $time');
                          _timeEnd = '${time.hour}:${time.minute}:${time.second}';
                          setState(() {});
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                        setState(() {});
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
                                        " $_timeEnd",
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
                ),
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
                NormalInput(isPassword: false, label: "Committee Code", inputType: TextInputType.text, controller: code, enable: false,),
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
                              if(_image == null) {
                                setState(() {
                                  _errorImage = "Please choose image";
                                });
                                _showToast("Please input all fields !", Colors.red);
                              } else if(_dateStart.contains("Not") || _timeStart.contains("Not") || _dateEnd.contains("Not") || _timeEnd.contains("Not")) {
                                setState(() {
                                  _errorImage = " ";
                                  _errorDateStart = "Please choose dates";
                                  _errorDateEnd = "Please choose dates";
                                });
                                _showToast("Please input all fields !", Colors.red);
                              } else {
                                dynamic _url = await _uploadService.uploadImageToFirebase(context, _image, "/uploads/images/events");
                                List<String> keywords = List<String>();
                                keywords.addAll(title.text.toLowerCase().split(""));
                                keywords.addAll(title.text.toUpperCase().split(""));
                                keywords.addAll(title.text.toLowerCase().split(" "));
                                keywords.addAll(title.text.toUpperCase().split(" "));
                                keywords.addAll(category.toLowerCase().split(""));
                                keywords.addAll(category.toUpperCase().split(""));
                                keywords.addAll(category.toLowerCase().split(" "));
                                keywords.addAll(category.toUpperCase().split(" "));
                                
                                Map<String, dynamic> _event = {
                                  "userCreated": user.uid,
                                  "committeeCode": code.text,
                                  "date": DateTime.now(),
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
                                  "time_end": convertDateFromString("$_dateEnd $_timeEnd"),
                                  "time_start": convertDateFromString("$_dateStart $_timeStart"),
                                  "title": title.text,
                                  "type": category,
                                  "keywords": keywords,
                                };
                                
                                Map<String, dynamic> _committee = {
                                  "committeeCode": code.text,
                                  "userId": user.uid,
                                  "level": "Creator"
                                };

                                await DatabaseServiceEvents().eventCreate(_event);
                                await DatabaseServiceEventCommittee().eventCommitteeCreate(_committee);
                                setState(() => loading = false);
                              }
                            }
                            setState(() => loading = false );
                          },
                          color: Colors.blue[400],
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            "Create",
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
                            
                          },
                          child: Text(
                            "Cancel",
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
}