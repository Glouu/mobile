import 'package:flutter/material.dart';
import 'package:gloou/screens/setttings/security/change_password/change_password.dart';
import 'package:gloou/shared/colors/colors.dart';
import 'package:gloou/widgets/toggle_widget.dart';

class Security extends StatefulWidget {
  const Security({Key? key}) : super(key: key);

  @override
  _SecurityState createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  final FocusNode toggleNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Security',
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
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          buildMenuItem(
            text: 'Change Password',
            isToggle: false,
            onToggleChange: (value) {},
            onClick: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangePassword()),
              );
            },
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
    double toggleSize = 1,
    double textSize = 16,
    bool value = false,
  }) {
    return ListTile(
      title: Text(
        text,
        style: TextStyle(
          color: Colors.black,
          fontSize: textSize,
        ),
      ),
      trailing: isToggle
          ? ToggleWidget(
              value: value,
              onChanged: onToggleChange,
              sizeNumber: toggleSize,
              toggleNode: toggleNode)
          : IconButton(
              color: Colors.black,
              onPressed: onClick,
              icon: Icon(Icons.arrow_forward_ios_rounded),
            ),
      hoverColor: mainColor,
      onTap: onClick,
    );
  }
}
