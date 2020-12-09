import 'dart:io';

import 'package:comat_apps/databases/db_users.dart';
import 'package:comat_apps/models/user.dart';
import 'package:comat_apps/models/user_detail.dart';
import 'package:comat_apps/databases/database.dart';
import 'package:comat_apps/services/upload_file.dart';
import 'package:comat_apps/ui/custom_widget/my_loading.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:comat_apps/ui/custom_widget/my_input.dart'; 

class SettingProfile extends StatefulWidget {
  @override
  _SettingProfileState createState() => _SettingProfileState();
}

class _SettingProfileState extends State<SettingProfile> {
  UploadService _uploadService = UploadService();
  File _imageFile;
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
            color: Colors.blue[400],
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ),
      body: StreamBuilder<UserDetail>(
        stream: DatabaseServiceUsers(uid: user.uid).userData,
        builder: (context, snapshot) {
          UserDetail userDetail = snapshot.data;
          TextEditingController _emailC;
          TextEditingController _nameC;
          TextEditingController _phoneC;
          if(userDetail != null) {
            _emailC = TextEditingController(text: userDetail.email);
            _nameC = TextEditingController(text: userDetail.name);
            _phoneC = TextEditingController(text: userDetail.phone);
          }
          return userDetail == null ? Center(child: CircularProgressIndicator()) : GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.only(left: 16, top: 25, right: 16),
                child: ListView(
                  children: [
                    Text(
                      "Edit Profile",
                      style: TextStyle(
                        fontSize: 25, fontWeight: FontWeight.w500
                      ),
                    ),
                    SizedBox(height: 15,),
                    Center(
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
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: _imageFile != null ? FileImage(_imageFile) : NetworkImage(userDetail.avatar),
                              )
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 4,
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                ),
                                color: Colors.blue[400]
                              ),
                              child: FlatButton(
                                padding: EdgeInsets.only(right: 20, left: 3),
                                onPressed: pickImage,
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 35,),
                    NormalInput(isPassword: false, label: "Full Name", hint: "Full Name", inputType: TextInputType.text,controller: _nameC,),
                    NormalInput(isPassword: false, label: "Email", hint: "Email", inputType: TextInputType.emailAddress,controller: _emailC,),
                    NormalInput(isPassword: false, label: "Phonenumber", hint: "+628xxxxxxxx",inputType: TextInputType.number, controller: _phoneC,),
                    // NormalInput(isPassword: true, label: "Password", value: userDetail.name,), 
                    SizedBox(height: 35,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlineButton(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          onPressed: () {
                            Navigator.pop(context);
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
                        RaisedButton(
                          onPressed: () async{
                            setState(() => loading = true );
                            if(_formKey.currentState.validate()) {
                              dynamic _url = await _uploadService.uploadImageToFirebase(context, _imageFile);
                              print(_url);
                              if(_url != "") {
                                await DatabaseServiceUsers(uid: user.uid).updateUser(
                                  _nameC.text ?? userDetail.name,
                                  _emailC.text ?? userDetail.email, 
                                  _url ?? userDetail.avatar, 
                                  _phoneC.text ?? userDetail.phone,
                                  userDetail.gSignIn
                                );
                                setState(() => loading = false);
                              }
                              Navigator.pop(context);
                            }
                            setState(() => loading = false );
                          },
                          color: Colors.blue[400],
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            "Save",
                            style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 2.2,
                              color: Colors.white
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}