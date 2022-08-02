import 'package:audioplayers/audioplayers.dart';
import 'package:clarityhub/domains/medias/models/media.dart';
import 'package:clarityhub/domains/medias/utilities/format.dart';
import 'package:clarityhub/theme.dart';
import 'package:flutter/material.dart';

class MediaAudioPlayer extends StatefulWidget {
  final Media media;

  MediaAudioPlayer(this.media);

  @override
  _MediaAudioPlayerState createState() => _MediaAudioPlayerState();
}

class _MediaAudioPlayerState extends State<MediaAudioPlayer> {
  AudioPlayer audioPlayer = AudioPlayer();
  Duration totalDuration = new Duration();
  Duration currentPosition = new Duration();
  AudioPlayerState playerState = AudioPlayerState.STOPPED;
  String error;

  play() async {
    if (playerState == AudioPlayerState.PAUSED) {
      await audioPlayer.resume();
    } else {
      var duration = Duration(milliseconds: 0);
      await audioPlayer.seek(duration);
      await audioPlayer.resume();
    }
  }

  pause() async {
    await audioPlayer.pause();
  }

  seek(double value) async {
    await audioPlayer.seek(Duration(milliseconds: (value).round()));
  }

  setup() async {
    await audioPlayer.setUrl(widget.media.presignedUrl);
  }

  @override
  void initState() {
    super.initState();

    setup();

    audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() => totalDuration = d);
    });

    audioPlayer.onAudioPositionChanged.listen((Duration  p) {
      setState(() => currentPosition = p);
    });

    audioPlayer.onPlayerStateChanged.listen((AudioPlayerState s) {
      setState(() => playerState = s);
    });

    audioPlayer.onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');
      setState(() {
        error = msg;
        playerState = AudioPlayerState.STOPPED;
        totalDuration = Duration(seconds: 0);
        currentPosition = Duration(seconds: 0);
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String now = '${format(currentPosition)}';
    String total = '${format(totalDuration)}';

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                ClipOval(
                  child: Material(
                    color: MyTheme.primary,
                    child: InkWell(
                      splashColor: Colors.red, // inkwell color
                      child: SizedBox(
                        width: 48,
                        height: 48,
                        child: playerState == AudioPlayerState.PLAYING ? 
                          Icon(Icons.pause, color: Colors.white, size: 32) : 
                          Icon(Icons.play_arrow, color: Colors.white, size: 32),
                      ),
                      onTap: () {
                        switch (playerState) {
                          case AudioPlayerState.PAUSED:
                          case AudioPlayerState.STOPPED:
                          case AudioPlayerState.COMPLETED: {
                            play();
                            break;
                          }
                          case AudioPlayerState.PLAYING:
                          default:
                            pause();
                        }
                      },
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Text(
                    '$now / $total'
                  ),
                ),

                totalDuration != null ? Container(
                  width: 150,
                  child: Slider(
                    activeColor: MyTheme.primary,
                    inactiveColor: MyTheme.primary.withAlpha(100),
                    value: currentPosition?.inMilliseconds?.toDouble() ?? 0.0,
                    onChanged: seek,
                    min: 0.0,
                    max: totalDuration.inMilliseconds.toDouble()
                  )
                )
                  : Text('')
              ],
            )
          ],
        )
      )
    );
  }
}