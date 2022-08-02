import 'package:clarityhub/theme.dart';
import 'package:flutter/material.dart';

@deprecated
class CustomText extends StatelessWidget {
  final String title;
  final Color color;
  final double size;
  final TextAlign alignment;
  final String fontFamily;

  CustomText({this.title, this.color, this.size, this.alignment, this.fontFamily});

  @override
  Widget build(BuildContext context) {
    double textSize = size;
    if (textSize == 0) textSize = MyTheme.normalTextSize();
    return Text(
      title,
      textAlign: alignment,
      style: TextStyle(
        fontSize: textSize,
        fontFamily: fontFamily ?? null,
        color: color,
      ),
    );
  }
}
