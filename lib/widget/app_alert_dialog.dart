import 'package:flutter/material.dart';

class AppAlertDialog extends StatelessWidget {
  final String title;
  final String title_button_yes;
  final String title_button_no;
  final String body;
  final Function onPressedYes;
  final Function onPressedNo;

  AppAlertDialog(this.title ,this.title_button_yes,this.title_button_no,{this.body,this.onPressedYes,this.onPressedNo});

  @override
  Widget build(BuildContext context) {
    return _requestPop(context);
  }
  _requestPop(context) {
    return  AlertDialog(
              title: Text(title),
              content: Text(body),
              actions: <Widget>[
                FlatButton(
                  child: Text(title_button_no),
                  onPressed:onPressedNo,
                ),
                FlatButton(
                  child: Text(title_button_yes),
                  onPressed: onPressedYes
                ),
              ],

            );
  }
}
