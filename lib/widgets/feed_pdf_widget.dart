import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gloou/shared/colors/colors.dart';
import 'package:gloou/widgets/svg_icon_widget.dart';
import 'package:gloou/widgets/text_icon_widget.dart';

class FeedPdfWidget extends StatelessWidget {
  final Uint8List profileImagePost;
  final String username;
  final String name;
  final String pdfTitle;
  final String pagesDetails;
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
  const FeedPdfWidget({
    Key? key,
    required this.profileImagePost,
    required this.username,
    required this.name,
    required this.pdfTitle,
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
    required this.pagesDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Wrap(
        children: [
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: EdgeInsets.only(
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
                  Card(
                    elevation: 0.2,
                    color: textFeedColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        print('this is for pdf files');
                      },
                      child: Row(
                        children: [
                          Container(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFDAE9FF),
                                border: Border.all(
                                  color: Color(0xFFDAE9FF),
                                  width: 20,
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                              ),
                              child: Icon(
                                Icons.folder,
                                color: Color(0xFF7CB0FF),
                                size: 40,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    pdfTitle,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(pagesDetails)
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
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
                      IconButton(
                        onPressed: onPressSave,
                        icon: Icon(
                          isSave
                              ? Icons.bookmark
                              : Icons.bookmark_border_rounded,
                        ),
                        color: isSave ? mainColor : Colors.black,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
