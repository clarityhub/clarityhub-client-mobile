import 'package:clarityhub/domains/app/widgets/mainScaffold.dart';
import 'package:flutter/material.dart';

class BackScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final floatingActionButton;
  final Widget icon;
  final Function onPressed;
  final List<Widget> actions;

  BackScaffold({ this.title, this.body, this.floatingActionButton, this.icon, this.onPressed, this.actions });

  _navigate(context) {
    return ([data]) {
      Navigator.of(context).pop(data);
    };
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      body: body,
      title: title,
      actions: actions,
      floatingActionButton: this.floatingActionButton,
      drawer: false,
      leading: new IconButton(
        icon: icon ?? new Icon(Icons.arrow_back),
        onPressed: () {
          if (this.onPressed != null) {
            onPressed(_navigate(context));
          } else {
            _navigate(context)();
          }
        },
      ),
    );
  }
}