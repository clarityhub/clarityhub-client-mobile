import 'package:clarityhub/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderText extends StatelessWidget {
    final String text;
    HeaderText(this.text);

    @override
    Widget build(BuildContext context) {
        return Text(
            text,
            style: GoogleFonts.roboto(
                fontWeight: FontWeight.w500,
                fontSize: MyTheme.largeText()
            ),
        );
    }
}