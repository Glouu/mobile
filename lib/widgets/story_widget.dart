import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gloou/shared/colors/colors.dart';

class StoryWidget extends StatelessWidget {
  final Uint8List img;
  final String username;
  const StoryWidget({
    Key? key,
    required this.img,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: 20,
        bottom: 10,
      ),
      child: Column(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: storyColors,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: MemoryImage(img),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          SizedBox(
            width: 70,
            child: Text(
              username,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }
}
