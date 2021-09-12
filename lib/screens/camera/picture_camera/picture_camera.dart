import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class PictureCamera extends StatefulWidget {
  const PictureCamera({Key? key}) : super(key: key);

  @override
  _PictureCameraState createState() => _PictureCameraState();
}

class _PictureCameraState extends State<PictureCamera> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  double cameraHorizontalPosition = 0;

  Future<CameraDescription> getCamera() async {
    final c = await availableCameras();
    return c.first;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getCamera().then((camera) {
      setState(() {
        _cameraController = CameraController(
          camera,
          ResolutionPreset.medium,
        );

        _initializeControllerFuture = _cameraController.initialize();
        _initializeControllerFuture.whenComplete(() {
          setState(() {
            cameraHorizontalPosition = -(MediaQuery.of(context).size.width *
                    _cameraController.value.aspectRatio) /
                2;
          });
        });
        print(_cameraController);
        print(_initializeControllerFuture);
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
    return Stack(
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
        )
      ],
    );
  }
}
