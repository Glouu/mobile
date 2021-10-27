import 'dart:io';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gloou/screens/camera/display_file/display_file.dart';
import 'package:gloou/screens/camera/display_picture/display_picture.dart';
import 'package:gloou/screens/camera/display_video/display_video.dart';
import 'package:gloou/screens/general_home/general_home.dart';
import 'package:path_provider/path_provider.dart';

class CameraWidget extends StatefulWidget {
  final int selectedPage;
  final bool isPictureTaker;
  final bool isVideoTaker;
  final bool isPdfUpload;
  final bool isCameraRotate;
  final String platformName;
  final VoidCallback onUploadMedia;
  const CameraWidget({
    Key? key,
    required this.selectedPage,
    required this.isPictureTaker,
    required this.isVideoTaker,
    required this.isPdfUpload,
    required this.isCameraRotate,
    required this.onUploadMedia,
    required this.platformName,
  }) : super(key: key);

  @override
  _CameraWidgetState createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  late CameraController _cameraController;
  late List<CameraDescription> cameraList;
  late Future<void> _initializeControllerFuture;
  double cameraHorizontalPosition = 0;

  bool isCircular = true;
  bool isRecording = false;
  bool isFlashOn = false;
  bool isCameraFront = true;

  Future<List<CameraDescription>> getCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    final c = await availableCameras();
    return c;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getCamera().then((camera) {
      setState(() {
        cameraList = camera;
        _cameraController = CameraController(
          cameraList[0],
          ResolutionPreset.high,
        );

        _initializeControllerFuture = _cameraController.initialize();
        _initializeControllerFuture.whenComplete(() {
          setState(() {
            cameraHorizontalPosition = -(MediaQuery.of(context).size.width *
                    _cameraController.value.aspectRatio) /
                2;
            isCircular = false;
          });
        });
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(widget.selectedPage),
      body: isCircular
          ? Container(
              color: Colors.black,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: FutureBuilder(
                    future: _initializeControllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return CameraPreview(_cameraController);
                      } else {
                        return Container(
                          color: Colors.black,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    },
                  ),
                ),
                Positioned(
                  bottom: 0.0,
                  right: 50,
                  left: 50,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        IconButton(
                          onPressed: () async {
                            final result = FilePicker.platform.pickFiles(
                              type: widget.platformName == 'normal' ||
                                      widget.platformName == 'bottle'
                                  ? FileType.media
                                  : widget.platformName == 'timepod' ||
                                          widget.platformName == 'challenge'
                                      ? FileType.video
                                      : FileType.any,
                            );
                          },
                          icon: Icon(
                            Icons.image_outlined,
                            color: Colors.white,
                          ),
                        ),
                        widget.isPictureTaker
                            ? widget.isVideoTaker
                                ? Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      GestureDetector(
                                        onLongPressUp: stopVideo,
                                        onLongPress:
                                            isRecording ? null : takeVideo,
                                        onTap: isRecording ? null : takePhoto,
                                        child: isRecording
                                            ? Icon(
                                                Icons.radio_button_off,
                                                size: 90,
                                                color: Colors.red,
                                              )
                                            : Icon(
                                                Icons.radio_button_off,
                                                size: 90,
                                                color: Colors.white,
                                              ),
                                      ),
                                      Positioned(
                                        child: GestureDetector(
                                          onLongPressUp: stopVideo,
                                          onLongPress:
                                              isRecording ? null : takeVideo,
                                          onTap: isRecording ? null : takePhoto,
                                          child: Icon(
                                            Icons.brightness_1_rounded,
                                            size: 64,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                : GestureDetector(
                                    onTap: isRecording ? null : takePhoto,
                                    child: Icon(
                                      Icons.brightness_1_rounded,
                                      size: 90,
                                      color: Colors.white,
                                    ),
                                  )
                            : widget.isVideoTaker
                                ? Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      GestureDetector(
                                        onLongPressUp: stopVideo,
                                        onLongPress:
                                            isRecording ? null : takeVideo,
                                        child: isRecording
                                            ? Icon(
                                                Icons.radio_button_off,
                                                size: 90,
                                                color: Colors.red,
                                              )
                                            : Icon(
                                                Icons.radio_button_off,
                                                size: 90,
                                                color: Colors.white,
                                              ),
                                      ),
                                      Positioned(
                                        child: GestureDetector(
                                          onLongPressUp: stopVideo,
                                          onLongPress:
                                              isRecording ? null : takeVideo,
                                          child: Icon(
                                            Icons.brightness_1_rounded,
                                            size: 64,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),
                        widget.isPdfUpload
                            ? GestureDetector(
                                onTap: pickPdf,
                                child: SvgPicture.asset(
                                  'assets/images/upload_pdf.svg',
                                ),
                              )
                            : Container(),
                        widget.isCameraRotate
                            ? IconButton(
                                onPressed: () async {
                                  setState(() {
                                    setState(() {
                                      isCameraFront = !isCameraFront;
                                    });
                                    int positioning = isCameraFront ? 0 : 1;
                                    _cameraController = CameraController(
                                      cameraList[positioning],
                                      ResolutionPreset.high,
                                    );

                                    _initializeControllerFuture =
                                        _cameraController.initialize();
                                  });
                                },
                                icon: Icon(
                                  Icons.flip_camera_android,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  getAppBar(int index) {
    switch (index) {
      case 0:
        return AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            'Normal',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          leading: IconButton(
              onPressed: () {
                setState(() {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => GeneralHome()),
                    (route) => false,
                  );
                });
              },
              icon: Icon(Icons.close)),
          actions: [
            IconButton(
              icon: isFlashOn ? Icon(Icons.flash_on) : Icon(Icons.flash_off),
              onPressed: () {
                setState(() {
                  isFlashOn = !isFlashOn;
                });
                isFlashOn
                    ? _cameraController.setFlashMode(FlashMode.torch)
                    : _cameraController.setFlashMode(FlashMode.off);
              },
            )
          ],
        );
      case 1:
        return AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            'Challenge',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          leading: IconButton(
              onPressed: () {
                setState(() {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => GeneralHome()),
                    (route) => false,
                  );
                });
              },
              icon: Icon(Icons.close)),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  isFlashOn = !isFlashOn;
                });
                isFlashOn
                    ? _cameraController.setFlashMode(FlashMode.torch)
                    : _cameraController.setFlashMode(FlashMode.off);
              },
              icon: isFlashOn ? Icon(Icons.flash_on) : Icon(Icons.flash_off),
            )
          ],
        );
      case 2:
        return AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            'Bottle Message',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          leading: IconButton(
              onPressed: () {
                setState(() {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => GeneralHome()),
                    (route) => false,
                  );
                });
              },
              icon: Icon(Icons.close)),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  isFlashOn = !isFlashOn;
                });
                isFlashOn
                    ? _cameraController.setFlashMode(FlashMode.torch)
                    : _cameraController.setFlashMode(FlashMode.off);
              },
              icon: isFlashOn ? Icon(Icons.flash_on) : Icon(Icons.flash_off),
            )
          ],
        );
      case 3:
        return AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            'Timepod',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          leading: IconButton(
              onPressed: () {
                setState(() {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => GeneralHome()),
                    (route) => false,
                  );
                });
              },
              icon: Icon(Icons.close)),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  isFlashOn = !isFlashOn;
                });
                isFlashOn
                    ? _cameraController.setFlashMode(FlashMode.torch)
                    : _cameraController.setFlashMode(FlashMode.off);
              },
              icon: isFlashOn ? Icon(Icons.flash_on) : Icon(Icons.flash_off),
            )
          ],
        );
    }

    return null;
  }

  void takePhoto() async {
    try {
      await _initializeControllerFuture;

      final image = await _cameraController.takePicture();

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DisplayPicture(
            imagePath: image.path,
            platformName: widget.platformName,
          ),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  void takeVideo() async {
    try {
      await _initializeControllerFuture;

      await _cameraController.startVideoRecording();

      setState(() {
        isRecording = true;
      });
    } catch (e) {
      print(e);
    }
  }

  void stopVideo() async {
    try {
      await _initializeControllerFuture;

      final video = await _cameraController.stopVideoRecording();

      setState(() {
        isRecording = false;

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DisplayVideo(
              videoPath: video.path,
              platformName: widget.platformName,
            ),
          ),
        );
      });
    } catch (e) {}
  }

  void pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['pdf'],
      type: FileType.custom,
    );
    if (result == null) return;

    final file = result.files.first;

    final newFile = await saveFilePermanently(file);

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DisplayFile(
          filePath: newFile.path,
          platformName: widget.platformName,
        ),
      ),
    );

    print(file.path);
  }

  Future<File> saveFilePermanently(PlatformFile file) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final newFile = File('${appStorage.path}/${file.name}');

    return File(file.path!).copy(newFile.path);
  }
}
