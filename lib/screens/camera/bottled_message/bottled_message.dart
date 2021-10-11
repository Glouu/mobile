import 'package:flutter/material.dart';
import 'package:gloou/widgets/camera_widget.dart';

class BottledMessage extends StatefulWidget {
  final int pageNumbber;
  const BottledMessage({Key? key, required this.pageNumbber}) : super(key: key);

  @override
  _BottledMessageState createState() => _BottledMessageState();
}

class _BottledMessageState extends State<BottledMessage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black,
        child: CameraWidget(
          selectedPage: widget.pageNumbber,
          isPdfUpload: true,
          isPictureTaker: true,
          isVideoTaker: true,
          isCameraRotate: false,
        ));
  }
}
