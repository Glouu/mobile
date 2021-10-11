import 'package:flutter/material.dart';
import 'package:gloou/screens/camera/bottled_message/bottled_message.dart';
import 'package:gloou/screens/camera/challenge/challenge.dart';
import 'package:gloou/screens/camera/picture_camera/picture_camera.dart';
import 'package:gloou/screens/camera/text/text_post.dart';
import 'package:gloou/screens/camera/timepod/timepod.dart';
import 'package:gloou/screens/general_home/general_home.dart';

class CameraSetUp extends StatefulWidget {
  const CameraSetUp({Key? key}) : super(key: key);

  @override
  _CameraSetUpState createState() => _CameraSetUpState();
}

class _CameraSetUpState extends State<CameraSetUp> {
  int _selectCameraIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(_selectCameraIndex),
      // IndexedStack(
      //   index: _selectCameraIndex,
      //   children: cameraPages,
      // ),
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

  getAppBar() {
    if (_selectCameraIndex == 4) {}
  }

  Widget getBody(int index) {
    switch (index) {
      case 0:
        return PictureCamera(
          pageNumbber: index,
        );
      case 1:
        return Challenge(
          pageNumbber: index,
        );
      case 2:
        return BottledMessage(
          pageNumbber: index,
        );
      case 3:
        return TimePod(
          pageNumbber: index,
        );
      case 4:
        return TextPost();
    }
    return Container(
      color: Colors.black,
      child: Center(
        child: Text(
          'Page Note Found',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
