import 'dart:io';
import 'dart:async';

import 'package:clarityhub/theme.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

class AddPhoto extends StatefulWidget {
  @override
  _AddPhotoState createState() => _AddPhotoState();
}

class _AddPhotoState extends State<AddPhoto> {
  bool isReady = false;
  CameraDescription selectedCamera;
  int numberOfCameras = 0;
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  String currentPath;
  bool showGallery = true;

  setup() async {
    final cameras = await availableCameras();

    setState(() {
      selectedCamera = cameras.first;
      numberOfCameras = cameras.length;
      isReady = true;

      _controller = CameraController(
        selectedCamera,
        ResolutionPreset.max,
      );
      _initializeControllerFuture = _controller.initialize();
    });
  }

  _takePhoto() async {
    try {
      await _initializeControllerFuture;

      final path = join(
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.png',
      );

      await _controller.takePicture(path);


      setState(() {
        currentPath = path;
      });
    } catch (e) {
      // TODO store and show the error
      // If an error occurs, log the error to the console.
      print(e);
    }
  }

  _switchCamera() async {
    setState(() {
      isReady = false;
    });

    final cameras = await availableCameras();

    setState(() {
      selectedCamera = cameras.firstWhere((camera) => camera != selectedCamera);

      _controller = CameraController(
        selectedCamera,
        ResolutionPreset.medium,
      );
      _initializeControllerFuture = _controller.initialize();

      isReady = true;
    });
  }

  _cancelPhoto() async {
    setState(() {
      currentPath = null;
    });
  }
  
  _acceptPhoto() async {
    Map<String, String> result = {
      'fileType': 'image/png',
      'path': currentPath,
    };
    Navigator.of(context).pop(result);
  }

  _handleGallery() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        currentPath = image.path;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIOverlays([]);

    setup();
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller.dispose();
    }
    
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
                child: FutureBuilder<void>(
                  future: _initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (currentPath != null) {
                      return Stack(
                        children: <Widget>[
                          Positioned.fill(
                            child: Container(
                              child: Image.file(File(currentPath)),
                            ),
                          ),

                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              child: Padding(
                                padding: EdgeInsets.all(32),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    ClipOval(
                                      child: Material(
                                        color: Colors.red,
                                        child: InkWell(
                                          splashColor: Colors.red,
                                          child: SizedBox(
                                            width: 54,
                                            height: 54,
                                            child: Icon(Icons.close, color: Colors.white, size: 32) 
                                          ),
                                          onTap: _cancelPhoto,
                                        ),
                                      ),
                                    ),

                                    ClipOval(
                                      child: Material(
                                        color: Colors.white,
                                        child: InkWell(
                                          splashColor: Colors.white,
                                          child: SizedBox(
                                            width: 54,
                                            height: 54,
                                            child: Icon(Icons.check, color: MyTheme.primary, size: 32) 
                                          ),
                                          onTap: _acceptPhoto,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          )
                        ]
                      );
                    }

                    if (!isReady) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.connectionState == ConnectionState.done) {
                      // If the Future is complete, display the preview.

                      final size = MediaQuery.of(context).size;
                      final deviceRatio = size.width / size.height;

                      return Stack(
                        children: <Widget>[
                          Positioned.fill(
                            child: Container(
                              child: Transform.scale(
                                scale: _controller.value.aspectRatio / deviceRatio,
                                child: Center(
                                  child: AspectRatio(
                                    aspectRatio: _controller.value.aspectRatio,
                                    child: CameraPreview(_controller),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              child: Padding(
                                padding: EdgeInsets.all(32),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    numberOfCameras > 1 ? new IconButton(
                                      iconSize: 32,
                                      icon: new Icon(Icons.switch_camera),
                                      color: Colors.white,
                                      onPressed: _switchCamera,
                                    ) : new IconButton(
                                      iconSize: 32,
                                      icon: new Icon(Icons.switch_camera),
                                      color: Colors.transparent,
                                      onPressed: () {},
                                    ),

                                    ClipOval(
                                      child: Material(
                                        color: MyTheme.primary,
                                        child: InkWell(
                                          splashColor: Colors.red, // inkwell color
                                          child: SizedBox(
                                            width: 60,
                                            height: 60,
                                            child: Icon(Icons.camera_alt, color: Colors.white, size: 32) 
                                          ),
                                          onTap: _takePhoto,
                                        ),
                                      ),
                                    ),

                                    showGallery ? new IconButton(
                                      iconSize: 32,
                                      icon: new Icon(Icons.photo_size_select_actual),
                                      color: Colors.white,
                                      onPressed: _handleGallery,
                                    ) : new IconButton(
                                      iconSize: 32,
                                      icon: new Icon(Icons.photo_size_select_actual),
                                      color: Colors.transparent,
                                      onPressed: () {}
                                    ),
                                  ],
                                ),
                              ),
                            )
                          )
                        ],
                      );
                    } else {
                      // Otherwise, display a loading indicator.
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                )
              ),

              Positioned(
                top: 32,
                left: 32,
                child: Container(
                  child: new IconButton(
                    iconSize: 32,
                    icon: new Icon(Icons.arrow_back),
                    color: Colors.white,
                    onPressed: () => Navigator.of(context).pop(false),
                  )
                ),
              ),
          ],
        )
      )
    );
  }  
}