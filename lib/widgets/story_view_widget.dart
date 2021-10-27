import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gloou/shared/api_environment/api_utils.dart';
import 'package:gloou/shared/utilities/convert_image.dart';
import 'package:story_view/story_view.dart';

class StoryViewWidget extends StatefulWidget {
  final Map<String, dynamic> user;
  final List<dynamic> userData;
  final PageController controller;
  final String token;
  const StoryViewWidget({
    Key? key,
    required this.user,
    required this.controller,
    required this.token,
    required this.userData,
  }) : super(key: key);

  @override
  _StoryViewWidgetState createState() => _StoryViewWidgetState();
}

class _StoryViewWidgetState extends State<StoryViewWidget> {
  final storyItems = <StoryItem>[];
  StoryController controller = StoryController();
  String userName = '';
  bool isCircular = true;

  final ConvertImage convertImage = ConvertImage();

  void addStoryItem() {
    for (final story in widget.user['stories']) {
      print(story);
      switch (story['fileType']) {
        case 'image/jpeg':
          storyItems.add(
            StoryItem.pageImage(
              url: ApiUtils.API_URL + '/Story/GetFile/${story['fileName']}',
              controller: controller,
              requestHeaders: <String, String>{
                HttpHeaders.contentTypeHeader: 'application/json',
                HttpHeaders.authorizationHeader: 'Bearer ${widget.token}'
              },
            ),
          );
          break;
        case 'video/mp4':
          storyItems.add(
            StoryItem.pageVideo(
                ApiUtils.API_URL + '/Story/GetFile/${story['fileName']}',
                controller: controller,
                requestHeaders: <String, String>{
                  HttpHeaders.contentTypeHeader: 'application/json',
                  HttpHeaders.authorizationHeader: 'Bearer ${widget.token}'
                }),
          );
          break;
      }
    }
  }

  void handleComplete() {
    widget.controller.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );

    var userData = widget.userData;
    final currentIndex = userData.indexOf(widget.user);
    final isLastPage = userData.length - 1 == currentIndex;

    if (isLastPage) {
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = StoryController();
    addStoryItem();
    isCircular = false;

    userName = widget.user['userName'];
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Material(
          type: MaterialType.transparency,
          child: StoryView(
            storyItems: storyItems,
            controller: controller,
            onComplete: handleComplete,
            onVerticalSwipeComplete: (direction) {
              if (direction == Direction.down) {
                Navigator.of(context).pop();
              }
            },
            onStoryShow: (storyItem) {
              final index = storyItems.indexOf(storyItem);

              if (index > 0) {
                setState(() {
                  userName = widget.user['userName'];
                });
              }
            },
          ),
        ),
        buildProfile(
          user: widget.user,
          userName: userName,
        )
      ],
    );
  }

  Widget buildProfile({
    required Map<String, dynamic> user,
    required String userName,
  }) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 90,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: MemoryImage(
                convertImage.formatBase64(user['userImage']),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user['firstName'] + ' ' + user['lastName'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '@' + userName,
                  style: TextStyle(color: Colors.white),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
