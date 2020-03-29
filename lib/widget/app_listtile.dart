import 'package:flutter/material.dart';

class AppListTile extends StatelessWidget {

  final String text;
  final Function onTap;
  final IconData icon;
   AppListTile(this.text ,{this.onTap,this.icon});
  @override
  Widget build(BuildContext context) {
    return _listTile();
  }
   _listTile() {
   return Padding(
      padding: EdgeInsets.all(10.0),
      child:ListTile(
        leading:  Icon(icon),
        title: Text(text,
          style: TextStyle(color: Colors.red, fontSize: 20.0),
        ),
        onTap: onTap,
      ),
    );
  }
}
