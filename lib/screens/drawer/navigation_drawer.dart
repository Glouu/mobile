import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gloou/screens/edit_profile/edit_profile.dart';
import 'package:gloou/screens/log_in/log_in.dart';
import 'package:gloou/screens/setttings/settings.dart';
import 'package:gloou/shared/api_environment/api_utils.dart';
import 'package:gloou/shared/colors/colors.dart';
import 'package:gloou/shared/secure_storage/secure_storage.dart';
import 'package:gloou/shared/token/token.dart';
import 'package:gloou/shared/utilities/convert_image.dart';
import 'package:gloou/widgets/toggle_widget.dart';
import 'package:http/http.dart' as http;

class NavigationDrawer extends StatefulWidget {
  // const NavigationDrawer({Key? key}) : super(key: key);
  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  final FocusNode toggleNode = FocusNode();

  final ConvertImage convertImage = ConvertImage();
  final TokenLogic tokenLogic = TokenLogic();

  late Map<String, dynamic> userInfo;

  final padding = EdgeInsets.symmetric(horizontal: 20);

  bool value = false;
  bool isCircular = true;
  final SecureStorage secureStorage = SecureStorage();

  init() async {
    var token = await tokenLogic.getToken();
    if (token != null) {
      var url = Uri.parse(ApiUtils.API_URL + '/User/GetUser');
      var httpClient = http.Client();
      var response = await httpClient.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        },
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        // var jsonError = jsonDecode(response.body);
      }
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => LogIn(),
        ),
        (route) => false,
      );
    }
  }

  @override
  void initState() {
    init().then((data) {
      setState(() {
        userInfo = data['data'];
        isCircular = false;
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        child: ListView(
          padding: padding,
          children: [
            SizedBox(
              height: 4,
            ),
            isCircular
                ? Container(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Spacer(),
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            CircularProgressIndicator(),
                          ],
                        ),
                      ],
                    ),
                  )
                : buildHeader(
                    image: convertImage.formatBase64(userInfo['image']),
                    name: userInfo['firstName'] + ' ' + userInfo['lastName'],
                    onClick: () => selectedPage(context, 0),
                    userName: '@' + userInfo['userName'],
                  ),
            SizedBox(
              height: 4,
            ),
            buildMenuItem(
              color: Colors.black,
              text: 'Glooucast',
              icon: Icons.mic_none,
              onClick: () => selectedPage(context, 1),
              follow: false,
              onToggleChanged: (value) {},
            ),
            SizedBox(
              height: 4,
            ),
            buildMenuItem(
              color: Colors.black,
              text: 'Switch to group profile',
              icon: Icons.groups_outlined,
              onClick: () {},
              follow: true,
              onToggleChanged: (value) {
                print(value);
                setState(() {
                  this.value = value;
                });
              },
            ),
            SizedBox(
              height: 4,
            ),
            buildMenuItem(
              color: Colors.black,
              text: 'Groups',
              icon: Icons.groups_sharp,
              onClick: () => selectedPage(context, 2),
              follow: false,
              onToggleChanged: (value) {},
            ),
            // SizedBox(
            //   height: 4,
            // ),
            // buildMenuItem(
            //   color: Colors.black,
            //   text: 'Bookmarks',
            //   icon: Icons.bookmark_border_rounded,
            //   onClick: () => selectedPage(context, 3),
            //   follow: false,
            //   onToggleChanged: (value) {},
            // ),
            SizedBox(
              height: 4,
            ),
            buildMenuItem(
              color: Colors.black,
              text: 'Settings',
              icon: Icons.settings_outlined,
              onClick: () => selectedPage(context, 4),
              follow: false,
              onToggleChanged: (value) {},
            ),
            // SizedBox(
            //   height: 4,
            // ),
            // buildMenuItem(
            //   color: Colors.black,
            //   text: 'Help',
            //   icon: Icons.help_outline,
            //   onClick: () => selectedPage(context, 5),
            //   follow: false,
            //   onToggleChanged: (value) {},
            // ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 8,
            ),
            buildMenuItem(
              color: Colors.red,
              text: 'Logout',
              icon: Icons.logout_rounded,
              onClick: () => selectedPage(context, 6),
              follow: false,
              onToggleChanged: (value) {},
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader({
    required Uint8List image,
    required String name,
    required String userName,
    required VoidCallback onClick,
  }) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Row(
              children: [
                Spacer(),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: MemoryImage(image),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      userName,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClick,
    required bool follow,
    required ValueChanged onToggleChanged,
    required Color color,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(
        text,
        style: TextStyle(color: color),
      ),
      trailing: follow
          ? ToggleWidget(
              value: value,
              sizeNumber: 1,
              toggleNode: toggleNode,
              onChanged: onToggleChanged,
            )
          : null,
      hoverColor: mainColor,
      onTap: onClick,
    );
  }

  void selectedPage(BuildContext context, int index) {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditProfile(
              name: userInfo['firstName'] + ' ' + userInfo['lastName'],
              image: userInfo['image'],
              bio: userInfo['bio'],
              username: userInfo['userName'],
              emailOrPhone: userInfo['phoneNumber'] != ''
                  ? userInfo['phoneNumber']
                  : userInfo['email'],
            ),
          ),
        );
        break;
      case 1:
        print('Pod Cast');
        break;
      case 2:
        print('Groups');
        break;
      // case 3:
      //   print('Bookmarks');
      //   break;
      case 4:
        print('Settings');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Settings(),
          ),
        );
        break;
      // case 5:
      //   print('Help');
      //   break;
      case 6:
        setState(() {
          secureStorage.deleteSecureData('token');
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => LogIn(),
            ),
            (route) => false,
          );
        });
        break;
    }
  }
}
