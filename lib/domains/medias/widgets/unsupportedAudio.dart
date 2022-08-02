import 'package:clarityhub/domains/medias/models/media.dart';
import 'package:flutter/material.dart';

class UnsupportedAudio extends StatelessWidget {
  final Media media;

  UnsupportedAudio(this.media);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[Text('Unsupported audio file')],
        )
      ),
    );
  }
}
