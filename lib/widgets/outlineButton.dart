import 'package:clarityhub/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CHOutlineButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final bool isLoading;

  CHOutlineButton({ this.text, this.onPressed, this.isLoading = false });

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (isLoading) {
      content = Center(
        child: SizedBox(
          height: 16,
          width: 16,
          child: CircularProgressIndicator()
        )
      );
    } else {
      content = Text(
        text.toUpperCase(),
        style: GoogleFonts.openSans(
          textStyle: TextStyle(
            color: MyTheme.primary,
            fontSize: MyTheme.normalTextSize(),
            fontWeight: FontWeight.w600,
          )
        ),
      );
    }
    return OutlineButton(
      borderSide: BorderSide(color: MyTheme.primary),
      padding: const EdgeInsets.all(8),
      child: content,
      onPressed: () {
        if (!isLoading) {
          onPressed();
        }
      }
    );
  }
}