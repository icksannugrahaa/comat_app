import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyImagePicker extends StatefulWidget {
  final File imageF;
  final String imageN;
  final String errorImage;
  final dynamic picker;
  final bool isProfile;
  final Function setImageState;

  MyImagePicker({this.imageF, this.errorImage, this.picker, this.imageN, this.setImageState, this.isProfile});

  @override
  _MyImagePickerState createState() => _MyImagePickerState();
}

class _MyImagePickerState extends State<MyImagePicker> {
  _imgFromCamera() async {
    PickedFile _pickedFile = await widget.picker.getImage(
      source: ImageSource.camera, imageQuality: 50
    );
    widget.setImageState(_pickedFile);
  }

  _imgFromGallery() async {
    PickedFile _pickedFile = await widget.picker.getImage(
      source: ImageSource.gallery, imageQuality: 50
    );
    widget.setImageState(_pickedFile);
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
                    title: new Text('Ambil dari Penyimpanan Galeri'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Ambil dari Kamera'),
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

  @override
  Widget build(BuildContext context) {
    return widget.isProfile 
    ? Center(
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
              image: widget.imageF != null 
                ? DecorationImage(
                  fit: BoxFit.cover,
                  image: FileImage(widget.imageF)
                )
                : DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(widget.imageN),
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
                onPressed: () => _showPicker(context),
                child: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    )
    : Center(
      child: GestureDetector(
        onTap: () => _showPicker(context),
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
              child: widget.imageF != null || widget.imageN != null
              ? ClipRRect(
                  // borderRadius: BorderRadius.circular(50),
                  child: widget.imageF != null 
                  ? Image.file(
                    widget.imageF,
                    fit: BoxFit.fitHeight,
                  )
                  : Image.network(
                    widget.imageN,
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
    );
  }
}
