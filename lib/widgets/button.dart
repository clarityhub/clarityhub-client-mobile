import 'package:clarityhub/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CHButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final bool isLoading;

  CHButton({ this.text, this.onPressed, this.isLoading = false });

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (isLoading) {
      content = Center(
        child: SizedBox(
          height: 16,
          width: 16,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.white),
          )
        )
      );
    } else {
      content = Text(
        text.toUpperCase(),
        style: GoogleFonts.openSans(
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: MyTheme.normalTextSize(),
            fontWeight: FontWeight.w600,
          )
        ),
      );
    }

    return RaisedButton(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: content,
      onPressed: () {
        if (!isLoading) {
          onPressed();
        }
      }
    );
  }
}