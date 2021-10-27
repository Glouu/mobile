import 'package:flutter/material.dart';
import 'package:gloou/screens/camera/bottled_message/bottled_message.dart';
import 'package:gloou/screens/camera/challenge/challenge.dart';
import 'package:gloou/screens/camera/picture_camera/picture_camera.dart';
import 'package:gloou/screens/camera/text/text_post.dart';
import 'package:gloou/screens/camera/timepod/timepod.dart';
import 'package:gloou/screens/general_home/general_home.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class CameraSetUp extends StatefulWidget {
  const CameraSetUp({Key? key}) : super(key: key);

  @override
  _CameraSetUpState createState() => _CameraSetUpState();
}

class _CameraSetUpState extends State<CameraSetUp> {
  int _selectCameraIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      body: getBody(_selectCameraIndex),
      // IndexedStack(
      //   index: _selectCameraIndex,
      //   children: cameraPages,
      // ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectCameraIndex,
        selectedItemColor: isKeyboard ? Colors.black : Colors.white,
        unselectedItemColor: Colors.grey[500],
        backgroundColor: isKeyboard ? Colors.white : Colors.black,
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
          pageNumber: index,
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
        return KeyboardDismisser(
          gestures: [GestureType.onTap],
          child: TextPost(),
        );
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
