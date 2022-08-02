import 'dart:async';

import 'package:clarityhub/domains/app/widgets/backScaffold.dart';
import 'package:clarityhub/domains/medias/utilities/format.dart';
import 'package:clarityhub/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddAudio extends StatefulWidget {
  @override
  _AddAudioState createState() => _AddAudioState();
}

enum RecordingState {
  READY,
  RECORDING,
  DONE
}

class _AddAudioState extends State<AddAudio> {
  bool isReady = false;
  Future<FlutterSoundRecorder> flutterSoundRecorder;
  FlutterSoundRecorder recorder;
  StreamSubscription<RecordingDisposition> _recorderSubscription;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String currentPath;
  Duration currentPosition = Duration(milliseconds: 0);
  Duration totalDuration = Duration(hours: 2);
  RecordingState recordingState = RecordingState.READY;

  setup() async {
    flutterSoundRecorder = new FlutterSoundRecorder().openAudioSession();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    var initializationSettingsAndroid = AndroidInitializationSettings('simple_transparent');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
      initializationSettingsAndroid,
      initializationSettingsIOS
    );

    await flutterSoundRecorder;
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    setState(() {
      isReady = true;
    });
  }

  _startRecording() async {
    // Request Microphone permission if needed
    PermissionStatus status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      // throw RecordingPermissionException("Microphone permission not granted");
      Fluttertoast.showToast(
        msg: 'Microphone permission is required to record',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 3,
        backgroundColor: MyTheme.error,
        textColor: Colors.white,
        fontSize: 16.0
      );
    }

    String extension = 'wav';
    Codec codec = Codec.pcm16WAV;

    final path = join(
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.$extension',
      );
    recorder = await flutterSoundRecorder;
    await recorder.startRecorder(
      toFile: path,
      codec: codec
    );

    _recorderSubscription = recorder.onProgress.listen((e) {
      setState(() {
        currentPosition = e.duration;
      
        // auto-stop at 2 hours
        if (currentPosition.inHours >= 2) {
          _stopRecording();
        }
      });
    });

    AndroidNotificationDetails android = new AndroidNotificationDetails('clarityhub', 'recording', 'Clarity Hub Recording notification channel',
      enableVibration: false,
      playSound: false,
      indeterminate: true,
      autoCancel: false,
      ongoing: true,
      priority: Priority.Max,
    );
    IOSNotificationDetails iOS = new IOSNotificationDetails();
    NotificationDetails notificationDetails = new NotificationDetails(android, iOS);
    flutterLocalNotificationsPlugin.show(1, 'Recording...', 'Clarity Hub is currently recording', notificationDetails);

    setState(() {
      currentPath = path;
      recordingState = RecordingState.RECORDING;
    });
  }

  _stopRecording() async {
    if (recorder != null) {
      recorder.stopRecorder();

      setState(() {
        recordingState = RecordingState.DONE;
      });

      if (_recorderSubscription != null) {
        _recorderSubscription.cancel();
        _recorderSubscription = null;
      }

      flutterLocalNotificationsPlugin.cancel(1);

      // TODO auto-accepting recording for now
      _acceptRecording();
    }
  }

  _acceptRecording() async {
    Map<String, String> result = {
      'fileType': 'audio/wav',
      'path': currentPath,
    };
    Navigator.of(context).pop(result);
  }

  _cancelled() {
    _stopRecording();

  }

  @override
  void initState() {
    super.initState();

    setup();
  }

  @override
  void dispose() {
    if (recorder != null) {
      recorder.closeAudioSession();
    }

    if (_recorderSubscription != null) {
      _recorderSubscription.cancel();
      _recorderSubscription = null;
    }

    flutterLocalNotificationsPlugin.cancelAll();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackScaffold(
      title: "Record",
      icon: Icon(Icons.close),
      onPressed: (next) {
        _cancelled();

        next();
      },
      body: Container(
        child: Column(
          children: <Widget>[
            FutureBuilder<void>(
              future: flutterSoundRecorder,
              builder: (context, snapshot) {
                if (currentPath != null) {
                  // TODO show accept
                }

                if (!isReady) {
                  return Center(child: CircularProgressIndicator());
                }

                // Show recorder card
                return Center(child: renderCard(recordingState));
              }
            )
          ]
        )
      ),
    );
  }

  Widget renderCard(recordingState) {
    String now = '${format(currentPosition)}';
    String total = '${format(totalDuration)}';

    Widget icon;
    Color color;

    switch (recordingState) {
      case RecordingState.READY:
        icon = Icon(Icons.fiber_manual_record, color: Colors.white, size: 32);
        color = MyTheme.primary;
        break;
      case RecordingState.RECORDING:
        icon = Icon(Icons.stop, color: Colors.white, size: 32);
        color = Colors.red;
        break;
      case RecordingState.DONE:
      default:
        icon = Icon(Icons.hourglass_empty, color: Colors.white, size: 32);
        color = Colors.grey;
    }

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
                    color: color,
                    child: InkWell(
                      splashColor: Colors.red, // inkwell color
                      child: SizedBox(
                        width: 48,
                        height: 48,
                        child: icon,
                      ),
                      onTap: () {
                        switch (recordingState) {
                          case RecordingState.READY:
                            _startRecording();
                            return;
                          case RecordingState.RECORDING:
                            _stopRecording();
                            return;
                          case RecordingState.DONE:
                          default:
                            return;
                        }
                      }
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
                    onChanged: null,
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