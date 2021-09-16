import 'package:flutter/material.dart';

class CloseAppBarWidget extends StatelessWidget {
  final Widget leading;

  const CloseAppBarWidget({Key? key, required this.leading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.black,
      elevation: 0.0,
      iconTheme: IconThemeData(color: Colors.white),
      title: Text(
        'Camera',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      leading: leading,
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.flash_auto),
        )
      ],
    );
  }
}
