import 'package:flutter/material.dart';
import 'package:gloou/widgets/camera_widget.dart';

class PictureCamera extends StatefulWidget {
  final int pageNumber;
  const PictureCamera({Key? key, required this.pageNumber}) : super(key: key);

  @override
  _PictureCameraState createState() => _PictureCameraState();
}

class _PictureCameraState extends State<PictureCamera> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black,
        child: CameraWidget(
          selectedPage: widget.pageNumber,
          isPdfUpload: true,
          isPictureTaker: true,
          isVideoTaker: true,
          isCameraRotate: false,
          onUploadMedia: () {},
          platformName: 'normal',
        ));
  }
}
