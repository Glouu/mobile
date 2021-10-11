import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gloou/widgets/camera_widget.dart';

class Challenge extends StatefulWidget {
  final int pageNumbber;
  const Challenge({Key? key, required this.pageNumbber}) : super(key: key);

  @override
  _ChallengeState createState() => _ChallengeState();
}

class _ChallengeState extends State<Challenge> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black,
        child: CameraWidget(
          selectedPage: widget.pageNumbber,
          isPdfUpload: false,
          isPictureTaker: false,
          isVideoTaker: true,
          isCameraRotate: true,
        ));
  }
}
