import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gloou/shared/colors/colors.dart';
import 'package:gloou/widgets/svg_icon_widget.dart';
import 'package:gloou/widgets/text_icon_widget.dart';

class FeedTextWidget extends StatelessWidget {
  final Uint8List profileImagePost;
  final String username;
  final String name;
  final String texPost;
  final VoidCallback onPressLike;
  final VoidCallback onPressComment;
  final VoidCallback onPressShare;
  final VoidCallback onPressSave;
  final bool isLike;
  final bool isShare;
  final bool isSave;
  final String countLikes;
  final String countComments;
  final String countShare;
  const FeedTextWidget({
    Key? key,
    required this.profileImagePost,
    required this.username,
    required this.name,
    required this.texPost,
    required this.onPressLike,
    required this.onPressComment,
    required this.onPressShare,
    required this.onPressSave,
    required this.isLike,
    required this.isShare,
    required this.isSave,
    required this.countLikes,
    required this.countComments,
    required this.countShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Card(
          elevation: 0.1,
          color: textFeedColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20,
              bottom: 10,
              top: 20,
              right: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: MemoryImage(
                                profileImagePost,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              '@' + username,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Icon(
                      Icons.more_horiz_rounded,
                      color: Colors.black,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  texPost,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextIconWidget(
                      icons: isLike
                          ? Icons.favorite
                          : Icons.favorite_border_rounded,
                      iconSize: 28,
                      value: countLikes,
                      onPress: onPressLike,
                      color: isLike ? Colors.red : Colors.black,
                    ),
                    SvgIconWidget(
                      imageLoc: 'assets/images/comment.svg',
                      value: countComments,
                      onPress: onPressComment,
                      color: Colors.black,
                    ),
                    TextIconWidget(
                      icons: Icons.cached_rounded,
                      iconSize: 30,
                      value: countShare,
                      onPress: onPressShare,
                      color: isShare ? mainColor : Colors.black,
                    ),
                    Bounce(
                      child: Icon(
                        isSave ? Icons.bookmark : Icons.bookmark_border_rounded,
                      ),
                      duration: Duration(milliseconds: 500),
                      onPressed: onPressSave,
                    ),
                    // IconButton(
                    //   onPressed: onPressSave,
                    //   icon: Icon(
                    //     isSave
                    //         ? Icons.bookmark
                    //         : Icons.bookmark_border_rounded,
                    //   ),
                    //   color: isSave ? mainColor : Colors.black,
                    // ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget iconText(
    IconData icons,
    double iconSize,
    String value,
    VoidCallback onPress,
    Color color,
  ) {
    return Row(
      children: [
        IconButton(
          onPressed: onPress,
          icon: Icon(icons),
          color: color,
          iconSize: iconSize,
        ),
        Text(
          value,
          style: TextStyle(color: color),
        )
      ],
    );
  }

  Widget svgWithText(
    String imageLoc,
    String value,
    VoidCallback onPress,
  ) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: GestureDetector(
            child: SvgPicture.asset(
              imageLoc,
              color: Colors.black,
              height: 24,
              width: 24,
            ),
            onTap: onPress,
          ),
        ),
        Text(
          value,
          style: TextStyle(color: Colors.black),
        )
      ],
    );
  }
}
