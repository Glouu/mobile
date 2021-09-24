import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class Challenge extends StatefulWidget {
  const Challenge({Key? key}) : super(key: key);

  @override
  _ChallengeState createState() => _ChallengeState();
}

class _ChallengeState extends State<Challenge> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  double cameraHorizontalPosition = 0;

  bool isCircular = true;

  Future<CameraDescription> getCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
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
    return isCircular
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
              Positioned.fill(
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Container(
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 30,
                          right: 50,
                          left: 50,
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.image_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                    right: 20,
                                    bottom: 50,
                                  ),
                                  decoration: BoxDecoration(
                                    // border: Border.all(
                                    //   color: Colors.white,
                                    //   width: 3,
                                    // ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    onPressed: () async {
                                      try {
                                        await _initializeControllerFuture;

                                        final image = await _cameraController
                                            .takePicture();

                                        // await Navigator.of(context).push(
                                        //   MaterialPageRoute(
                                        //     builder: (context) =>
                                        //         DisplayPicture(
                                        //             imagePath: image.path),
                                        //   ),
                                        // );
                                      } catch (e) {
                                        print(e);
                                      }
                                    },
                                    icon: Icon(
                                      Icons.brightness_1_rounded,
                                      size: 64,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.upload,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
  }
}
