// System
import 'dart:io';
import 'package:comat_apps/ui/custom_widget/my_imagepicker.dart';
import 'package:comat_apps/ui/custom_widget/my_toast.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

// My Package
import 'package:comat_apps/databases/db_users.dart';
import 'package:comat_apps/models/user.dart';
import 'package:comat_apps/models/user_detail.dart';
import 'package:comat_apps/services/upload_file.dart';
import 'package:comat_apps/ui/custom_widget/my_appbar.dart';
import 'package:comat_apps/ui/custom_widget/my_loading.dart';
import 'package:comat_apps/ui/custom_widget/my_input.dart'; 

class SettingProfile extends StatefulWidget {
  @override
  _SettingProfileState createState() => _SettingProfileState();
}

class _SettingProfileState extends State<SettingProfile> {
  bool loading = false;
  UploadService _uploadService = UploadService();
  File _imageFile;
  TextEditingController _emailC;
  TextEditingController _nameC;
  TextEditingController _phoneC;
  String _errorImage = " ";
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  setImageState(PickedFile _pickedFile) {
    setState(() {
      if (_pickedFile != null) {
        _imageFile = File(_pickedFile.path);
      } else {
        _errorImage = "Tidak ada gambar yang dipilih !";
      }
    });
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
                child: ListView(
                  padding: EdgeInsets.all(20),
                  children: [
                    Text(
                      "Edit Profile",
                      style: TextStyle(
                        fontSize: 25, fontWeight: FontWeight.w500
                      ),
                    ),
                    SizedBox(height: 15,),
                    MyImagePicker(imageF: _imageFile, errorImage: _errorImage, picker: picker, imageN: userDetail.avatar, setImageState: setImageState,isProfile: true,),
                    SizedBox(height: 15,),
                    Center(
                      child: Text(
                        _errorImage,
                        style: TextStyle(
                          color: Colors.red
                        ),
                      )
                    ),
                    SizedBox(height: 35,),
                    NormalInput(isPassword: false, label: "Full Name", hint: "Full Name", inputType: TextInputType.text,controller: _nameC,),
                    NormalInput(isPassword: false, label: "Email", hint: "Email", inputType: TextInputType.emailAddress,controller: _emailC, enable: false,),
                    NormalInput(isPassword: false, label: "Phonenumber", hint: "+628xxxxxxxx",inputType: TextInputType.number, controller: _phoneC,),
                    SizedBox(height: 35,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RaisedButton(
                          onPressed: () async{
                            setState(() => loading = true );
                            if(_formKey.currentState.validate()) {
                              dynamic _url;
                              if(_imageFile != null) {
                                if(userDetail.avatar.contains('firebasestorage')) {
                                  await _uploadService.deleteImageFromFirebase(userDetail.avatar);
                                }
                                _url = await _uploadService.uploadImageToFirebase(context, _imageFile, "/uploads/images/users");
                              } else {
                                _url = userDetail.avatar;
                              }

                              await DatabaseServiceUsers(uid: user.uid).updateUser(
                                _nameC.text ?? userDetail.name,
                                _emailC.text ?? userDetail.email, 
                                _url, 
                                _phoneC.text ?? userDetail.phone,
                                userDetail.gSignIn
                              );
                              setState(() {
                                loading = false;
                                _errorImage = " ";
                              });
                              myToast("Profile berhasil diubah !", Colors.green[400]);
                            } else {
                              myToast("Tolong lengkapi profile anda !", Colors.red);
                            }
                            setState(() => loading = false );
                          },
                          color: Colors.blue[400],
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            "Simpan",
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
                            Navigator.pop(context);
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