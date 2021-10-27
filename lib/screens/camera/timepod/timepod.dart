import 'package:flutter/material.dart';
import 'package:gloou/widgets/camera_widget.dart';

class TimePod extends StatefulWidget {
  final int pageNumbber;
  const TimePod({Key? key, required this.pageNumbber}) : super(key: key);

  @override
  _TimePodState createState() => _TimePodState();
}

class _TimePodState extends State<TimePod> {
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
          platformName: 'timepod',
          onUploadMedia: () {},
        ));
  }
}
