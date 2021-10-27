import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gloou/widgets/camera_widget.dart';

class StoryCamera extends StatefulWidget {
  const StoryCamera({Key? key}) : super(key: key);

  @override
  _StoryCameraState createState() => _StoryCameraState();
}

class _StoryCameraState extends State<StoryCamera> {
  late CameraController _cameraController;
  late List<CameraDescription> cameraList;

  bool isFlashOn = false;

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
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Story',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            setState(() {
              Navigator.of(context).pop();
            });
          },
          icon: Icon(Icons.close),
        ),
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
      ),
      body: CameraWidget(
        selectedPage: 4,
        isPictureTaker: true,
        isVideoTaker: true,
        isPdfUpload: false,
        isCameraRotate: true,
        onUploadMedia: () {},
        platformName: 'story',
      ),
    );
  }
}
