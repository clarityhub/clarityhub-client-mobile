import 'package:clarityhub/domains/interviews/pages/addinterview.dart';
import 'package:clarityhub/theme.dart';
import 'package:clarityhub/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InterviewsEmptyGreeting extends StatelessWidget {
  _handleCreateInterview({ context }) {
    return () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => new AddInterview(),
        ),
      );
    };
  }

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
                  'Get Started',
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
                        'Get started by creating your first notebook.',
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                        child: Text(
                          'You can add audio recordings and photos to your notebooks!',
                          textAlign: TextAlign.center,
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                        child: CHButton(
                          onPressed: _handleCreateInterview(context: context),
                          text: 'Create Notebook',
                        ),
                      )
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