import 'package:flutter/material.dart';

class LinkButton extends StatelessWidget {
  final String title;
  final double size;
  final Function onPressed;

  LinkButton({this.title, this.size, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        title,
        style: TextStyle(
          color: Colors.blue,
          fontSize: size,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
