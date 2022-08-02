import 'package:clarityhub/theme.dart';
import 'package:flutter/material.dart';

class EditTextBox extends StatelessWidget {
  final autofocus;
  final String hint;
  final double size;
  final TextAlign alignment;
  final TextEditingController textEditingController;
  final int minLines, maxLines;

  EditTextBox({
    this.autofocus = false,
    this.hint,
    this.textEditingController,
    this.size,
    this.minLines,
    this.maxLines,
    @required this.alignment
  });

  @override
  Widget build(BuildContext context) {
    double textSize = size;
    if (textSize == 0) textSize = MyTheme.normalTextSize();

    return TextField(
      autofocus: autofocus,
      maxLines: maxLines,
      minLines: minLines,
      textAlign: alignment,
      obscureText: false,
      controller: textEditingController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: textSize,
          ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
