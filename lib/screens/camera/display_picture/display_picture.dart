import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gloou/widgets/button_widget.dart';

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
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
          icon: Icon(Icons.close),
        ),
      ),
      body: Container(
        color: Colors.black,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: FileImage(File(widget.imagePath)),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      // bottomSheet: Container(),
      bottomNavigationBar: Stack(
        children: [
          Container(
            height: 70,
            color: Colors.black,
          ),
          Positioned(
            right: 20.0,
            top: 10,
            child: Container(
              child: ButtonWidget(
                title: 'Next',
                onClick: () {},
                isButtonActive: false,
                buttonColor: Theme.of(context).primaryColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
