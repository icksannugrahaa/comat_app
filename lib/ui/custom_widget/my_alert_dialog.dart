import 'package:comat_apps/models/user_detail.dart';
import 'package:comat_apps/ui/custom_widget/my_toast.dart';
import 'package:flutter/material.dart';

myAlertDialog(BuildContext context,String message,UserDetail users, Function func, String notifMessage, Color notifColor, String route) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Batalkan"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Lanjutkan"),
      onPressed:  () async {
        func(users, true);
        myToast(notifMessage, notifColor);
        if(route != null) Navigator.pushReplacementNamed(context, route);
        else Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Konfirmasi"),
      content: Text(message),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }