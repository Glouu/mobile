import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gloou/shared/colors/colors.dart';
import 'package:gloou/widgets/svg_icon_widget.dart';
import 'package:gloou/widgets/text_icon_widget.dart';

class FeedVideoWidget extends StatelessWidget {
  final Uint8List videoPost;
  final Uint8List profileImagePost;
  final String username;
  final String name;
  final String postDescription;
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
  const FeedVideoWidget({
    Key? key,
    required this.videoPost,
    required this.profileImagePost,
    required this.name,
    required this.username,
    required this.postDescription,
    required this.onPressLike,
    required this.onPressComment,
    required this.onPressShare,
    required this.onPressSave,
    required this.isLike,
    required this.isShare,
    required this.countLikes,
    required this.countComments,
    required this.countShare,
    required this.isSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.all(15),
      child: Wrap(
        children: [
          Container(
            height: (size.height) / 1.8,
            child: Stack(children: [
              Container(
                height: (size.height) / 1.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: MemoryImage(
                      videoPost,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: (size.height) / 1.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.25),
                      Colors.black.withOpacity(0),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    bottom: 10,
                    top: 10,
                    right: 10,
                  ),
                  child: Stack(
                    children: [
                      // upper design
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white.withOpacity(0.40),
                                width: 10,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.play_circle,
                              color: Colors.white,
                            ),
                          ),
                          Icon(
                            Icons.more_horiz_rounded,
                            color: Colors.white,
                          )
                        ],
                      ),
                      // lower content
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
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
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    '@' + username,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            postDescription,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
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
                                color: isLike ? Colors.red : Colors.white,
                              ),
                              SvgIconWidget(
                                imageLoc: 'assets/images/comment.svg',
                                value: countComments,
                                onPress: onPressComment, color: Colors.white,
                              ),
                              TextIconWidget(
                                icons: Icons.cached_rounded,
                                iconSize: 30,
                                value: countShare,
                                onPress: onPressShare,
                                color: isShare ? mainColor : Colors.white,
                              ),
                              IconButton(
                                onPressed: onPressSave,
                                icon: Icon(
                                  isSave
                                      ? Icons.bookmark
                                      : Icons.bookmark_border_rounded,
                                ),
                                color: isSave ? mainColor : Colors.white,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
