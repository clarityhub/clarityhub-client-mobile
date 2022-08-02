import 'package:clarityhub/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTitle extends StatelessWidget {
    final String title;
    AppTitle(this.title);

    @override
    Widget build(BuildContext context) {
        return Text(
            title,
            style: GoogleFonts.roboto(
                fontWeight: FontWeight.w500,
                fontSize: MyTheme.headingSize()
            ),
        );
    }
}