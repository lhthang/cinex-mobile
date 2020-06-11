import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

Alert showErrorMessage(BuildContext context,String title,String text) {
  return Alert(
    context: context,
    type: AlertType.error,
    title: title,
    desc: text,
    buttons: [
      DialogButton(
        child: Text(
          "Close",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () => Navigator.pop(context),
        width: 120,
      )
    ],
  );
}

Alert showSuccessMessage(BuildContext context,String title,String text) {
  return Alert(
    context: context,
    type: AlertType.success,
    title: title,
    desc: text,
    buttons: [
      DialogButton(
        child: Text(
          "Close",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () => Navigator.pop(context),
        width: 120,
      )
    ],
  );
}
