import 'package:clarityhub/theme.dart';
import 'package:flutter/material.dart';

class ErrorCard extends StatelessWidget {
  final error;

  ErrorCard({ this.error });

  getErrorDescription(error) {
    try {
      if (error is Exception ) {
        return error.toString().replaceAll('Exception: ', '');
      } else {
        return error.toString();
      }
    } catch (e) {
      return 'Something bad happened';
    }
  }

  @override
  Widget build(BuildContext context) {
    MyTheme.init(context);

    return Card(
      color: Theme.of(context).errorColor,
      
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.error, color: Colors.white),
            title: Text(getErrorDescription(error), style: TextStyle(
              color: Colors.white,
            )),
          ),
        ],
      ),
    );
  }
}