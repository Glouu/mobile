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

  List<Widget> cameraPages = [
    PictureCamera(),
    Challenge(),
    BottledMessage(),
    TimePod(),
    TextPost(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
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
    if (_selectCameraIndex == 0) {
      return AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Normal',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
            onPressed: () {
              setState(() {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => GeneralHome()));
              });
            },
            icon: Icon(Icons.close)),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.flash_auto),
          )
        ],
      );
    }
    if (_selectCameraIndex == 1) {}
    if (_selectCameraIndex == 2) {}
    if (_selectCameraIndex == 3) {}
    if (_selectCameraIndex == 4) {}
  }

  Widget getBody(int index) {
    switch (index) {
      case 0:
        return PictureCamera();
      case 1:
        return Challenge();
      case 2:
        return BottledMessage();
      case 3:
        return TimePod();
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
