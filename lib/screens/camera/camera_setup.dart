import 'package:flutter/material.dart';
import 'package:gloou/screens/camera/picture_camera/picture_camera.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class CameraSetUp extends StatefulWidget {
  const CameraSetUp({Key? key}) : super(key: key);

  @override
  _CameraSetUpState createState() => _CameraSetUpState();
}

class _CameraSetUpState extends State<CameraSetUp> {
  int _selectCameraIndex = 0;

  List<Widget> cameraPages = [
    PictureCamera(),
    Container(),
    Container(),
    Container(),
    Container(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectCameraIndex,
        children: cameraPages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectCameraIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[500],
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.window_rounded),
            label: 'Picture',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle),
            label: 'Video',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.email_rounded),
            label: 'Email',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.hourglass_bottom),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sort_by_alpha),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          _selectCameraIndex = index;
          setState(() {});
        },
      ),
    );
  }
}
