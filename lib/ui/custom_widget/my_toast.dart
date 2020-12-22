import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

myToast(String _text, Color _bgColor) {
  return Fluttertoast.showToast(
      msg: _text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: _bgColor,
      textColor: Colors.white,
      fontSize: 16.0
  );
}

