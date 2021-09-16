import 'dart:io';

import 'package:flutter/material.dart';

class DisplayPicture extends StatefulWidget {
  final String imagePath;
  const DisplayPicture({Key? key, required this.imagePath}) : super(key: key);

  @override
  _DisplayPictureState createState() => _DisplayPictureState();
}

class _DisplayPictureState extends State<DisplayPicture> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Display Picture'),
      ),
      body: Image.file(
        File(widget.imagePath),
      ),
    );
  }
}
