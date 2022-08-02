import 'package:clarityhub/domains/interviews/models/interview.dart';
import 'package:clarityhub/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InterviewItem extends StatelessWidget {
  final Interview interview;
  final Function onView;

  InterviewItem({ this.interview, this.onView });

  String formatDate(String date) {
    try {
      DateTime dt = DateTime.parse(date);
      DateFormat df = new DateFormat.yMMMd();
    
      return df.format(dt);
    } catch(e) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onView,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                interview.title ?? '',
                style: TextStyle(
                  fontSize: MyTheme.headingSize(),
                  color: Colors.black,
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: interview.slateContent.renderPreview(context),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                formatDate(interview.createdAt),
                style: TextStyle(
                  fontSize: MyTheme.tinyTextSize(),
                  color: Colors.black26,
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}