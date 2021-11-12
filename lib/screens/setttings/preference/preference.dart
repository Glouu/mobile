import 'package:flutter/material.dart';
import 'package:gloou/screens/setttings/preference/interests/interests.dart';
import 'package:gloou/shared/colors/colors.dart';
import 'package:gloou/shared/secure_storage/secure_storage.dart';
import 'package:gloou/widgets/toggle_widget.dart';

class Preference extends StatefulWidget {
  const Preference({Key? key}) : super(key: key);

  @override
  _PreferenceState createState() => _PreferenceState();
}

class _PreferenceState extends State<Preference> {
  final FocusNode toggleNode = FocusNode();

  late bool showContentInLocation;
  bool isLoading = true;
  final SecureStorage secureStorage = SecureStorage();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() async {
    var isShowContentInLocation =
        await secureStorage.readSecureData('isShowContentInLocation');
    setState(() {
      if (isShowContentInLocation != null) {
        if (isShowContentInLocation == 'true') {
          showContentInLocation = true;
        } else {
          showContentInLocation = false;
        }
      } else {
        showContentInLocation = true;
      }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Preference',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: EdgeInsets.all(15),
              children: [
                buildMenuItem(
                  text: 'Interests',
                  isToggle: false,
                  onToggleChange: (value) {},
                  onClick: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Interest()),
                    );
                  },
                  isSideText: false,
                ),
                SizedBox(
                  height: 10,
                ),
                buildMenuItem(
                  text: 'Language',
                  isToggle: false,
                  onToggleChange: (value) {},
                  onClick: () {},
                  isSideText: true,
                  sideText: 'English',
                ),
                SizedBox(
                  height: 10,
                ),
                buildMenuItem(
                  text: 'Location',
                  isToggle: false,
                  onToggleChange: (value) {},
                  onClick: () {},
                  isSideText: true,
                  sideText: 'Lagos',
                ),
                SizedBox(
                  height: 10,
                ),
                buildMenuItem(
                  text: 'Show me content in my current location',
                  isToggle: true,
                  onToggleChange: (value) {
                    setState(() {
                      secureStorage.writeSecureData(
                        'isShowContentInLocation',
                        value.toString(),
                      );
                      this.showContentInLocation = value;
                    });
                  },
                  value: showContentInLocation,
                ),
              ],
            ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required bool isToggle,
    required ValueChanged onToggleChange,
    VoidCallback? onClick,
    String sideText = '',
    double toggleSize = 1,
    double textSize = 16,
    bool value = false,
    bool isSideText = false,
  }) {
    return isToggle
        ? ListTile(
            title: Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontSize: textSize,
              ),
            ),
            trailing: ToggleWidget(
                value: value,
                onChanged: onToggleChange,
                sizeNumber: toggleSize,
                toggleNode: toggleNode),
            hoverColor: mainColor,
            onTap: onClick,
          )
        : Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 15,
            ),
            child: InkWell(
              onTap: () {},
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      text,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: textSize,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(sideText),
                      IconButton(
                        color: Colors.black,
                        onPressed: onClick,
                        icon: Icon(Icons.arrow_forward_ios_rounded),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
