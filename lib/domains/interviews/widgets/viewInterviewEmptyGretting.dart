import 'package:clarityhub/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewInterviewEmptyGreeting extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: <Widget>[
                Text(
                  'Add photos or recordings',
                  style: GoogleFonts.roboto(
                    fontSize: MyTheme.largeText(),
                    fontWeight: FontWeight.w500,
                  )
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'You can add photos or record audio by clicking the button on the bottom right.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                )
              ],
            ),
          )
        )
      )
    );
  }
}