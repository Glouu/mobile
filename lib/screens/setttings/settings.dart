import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gloou/screens/setttings/bottle/bottle.dart';
import 'package:gloou/screens/setttings/cam_set/cam_set.dart';
import 'package:gloou/screens/setttings/preference/preference.dart';
import 'package:gloou/screens/setttings/push_notification/push_notification.dart';
import 'package:gloou/screens/setttings/security/security.dart';
import 'package:gloou/shared/colors/colors.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.close),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(15),
        children: [
          buildMenuItem(
            text: 'Push Notification',
            icon: Icons.arrow_forward_ios_rounded,
            imageLink: 'assets/images/push_notification.svg',
            onClick: () {
              selectedPage(context, 0);
            },
          ),
          SizedBox(
            height: 4,
          ),
          buildMenuItem(
            text: 'Security',
            icon: Icons.arrow_forward_ios_rounded,
            imageLink: 'assets/images/security.svg',
            onClick: () {
              selectedPage(context, 1);
            },
          ),
          SizedBox(
            height: 4,
          ),
          buildMenuItem(
            text: 'Camera',
            icon: Icons.arrow_forward_ios_rounded,
            imageLink: 'assets/images/camera.svg',
            onClick: () {
              selectedPage(context, 2);
            },
          ),
          SizedBox(
            height: 4,
          ),
          buildMenuItem(
            text: 'Bottle Message',
            icon: Icons.arrow_forward_ios_rounded,
            imageLink: 'assets/images/bottle_message.svg',
            onClick: () {
              selectedPage(context, 3);
            },
          ),
          SizedBox(
            height: 4,
          ),
          buildMenuItem(
            text: 'Preferences',
            icon: Icons.arrow_forward_ios_rounded,
            imageLink: 'assets/images/preferences.svg',
            onClick: () {
              selectedPage(context, 4);
            },
          ),
        ],
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClick,
    required String imageLink,
    double textSize = 16,
  }) {
    return ListTile(
      leading: SvgPicture.asset(imageLink),
      title: Text(
        text,
        style: TextStyle(
          color: Colors.black,
          fontSize: textSize,
        ),
      ),
      trailing: IconButton(
        color: Colors.black,
        onPressed: onClick,
        icon: Icon(icon),
      ),
      hoverColor: mainColor,
      onTap: onClick,
    );
  }

  void selectedPage(BuildContext context, int i) {
    switch (i) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PushNotification()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Security()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CamSet()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Bottle()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Preference()),
        );
        break;
    }
  }
}
