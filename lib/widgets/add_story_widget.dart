import 'dart:typed_data';

import 'package:flutter/material.dart';

class AddStoryWidget extends StatelessWidget {
  final Uint8List img;
  final String username;
  const AddStoryWidget({
    Key? key,
    required this.img,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: 20,
        left: 15,
        bottom: 10,
      ),
      child: Column(
        children: [
          Container(
            width: 65,
            height: 65,
            child: Stack(
              children: [
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(image: MemoryImage(img)),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 19,
                    height: 19,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Icon(
                      Icons.add_circle,
                      color: Colors.blue,
                      size: 19,
                    ),
                  ),
                ),
              ],
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
