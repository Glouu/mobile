import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gloou/shared/secure_storage/secure_storage.dart';
import 'package:gloou/widgets/button_widget.dart';
import 'package:gloou/widgets/pick_username_chip_widget.dart';
import 'package:gloou/widgets/text_media_widget.dart';
import 'package:gloou/widgets/toggle_widget.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:video_player/video_player.dart';

class DisplayVideo extends StatefulWidget {
  final String videoPath;
  const DisplayVideo({
    Key? key,
    required this.videoPath,
  }) : super(key: key);

  @override
  _DisplayVideoState createState() => _DisplayVideoState();
}

class _DisplayVideoState extends State<DisplayVideo> {
  late VideoPlayerController _videoPlayerController;
  final postFormKey = GlobalKey<FormState>();

  TextEditingController captionController = TextEditingController();

  final FocusNode captionNode = FocusNode();
  final FocusNode toggleNode = FocusNode();

  bool isSubmit = false;
  bool challengeValue = false;
  bool scheduleValue = false;

  late String status, message, token;

  final toast = FToast();

  final SecureStorage secureStorage = SecureStorage();

  late List followedUsers;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _videoPlayerController = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {
          _videoPlayerController.play();
        });
      });
  }

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
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: _videoPlayerController.value.isInitialized
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _videoPlayerController.value.isPlaying
                          ? _videoPlayerController.pause()
                          : _videoPlayerController.play();
                    });
                  },
                  child: AspectRatio(
                    aspectRatio: _videoPlayerController.value.aspectRatio,
                    child: VideoPlayer(_videoPlayerController),
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(),
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
                onClick: () {
                  setState(() {
                    _videoPlayerController.pause();
                  });
                  showSheet();
                },
                isButtonActive: false,
                buttonColor: Theme.of(context).primaryColor,
              ),
            ),
          )
        ],
      ),
    );
  }

  showSheet() => showSlidingBottomSheet(
        context,
        builder: (context) => SlidingSheetDialog(
          snapSpec: SnapSpec(snappings: [0.7, 1]),
          builder: buildSheet,
        ),
      );

  Widget buildSheet(context, state) => StatefulBuilder(builder:
          (BuildContext context, void Function(void Function()) setState) {
        return Material(
          child: KeyboardDismisser(
            gestures: [GestureType.onTap],
            child: Form(
              key: postFormKey,
              child: ListView(
                shrinkWrap: true,
                primary: false,
                padding: EdgeInsets.only(
                  left: 15,
                  right: 15,
                  bottom: 10,
                  top: 5,
                ),
                children: [
                  TextMediaWidget(
                    textInput: captionController,
                    textNode: captionNode,
                    maxLines: 4,
                    labelTitle: 'Caption',
                    validationMsg: (value) {},
                    prefix: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
                      child: Container(
                        width: 50,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: AspectRatio(
                          aspectRatio: _videoPlayerController.value.aspectRatio,
                          child: VideoPlayer(_videoPlayerController),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Challenge individual',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Builder(
                        builder: (context) => ToggleWidget(
                          value: challengeValue,
                          onChanged: (value) => setState(() {
                            print(value);
                            this.challengeValue = value;
                          }),
                          sizeNumber: 1.5,
                          toggleNode: toggleNode,
                        ),
                      )
                    ],
                  ),
                  challengeValue
                      ? ChipsFormWidget(
                          onChange: (data) {
                            print(data);
                          },
                          findSuggestions: (String query) {
                            if (query.isNotEmpty) {
                              var lowerCaseQuery = query.toLowerCase();
                              // return followedUsers.where((userInfo) {
                              //   return userInfo.name
                              // });
                            }

                            return followedUsers;
                          },
                          chipBuilder: (context, state, dynamic userInfo) {
                            return InputChip(
                              key: ObjectKey(userInfo),
                              label: Text(userInfo),
                              onDeleted: () => state.deleteChip(userInfo),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            );
                          },
                          suggestionBuilder:
                              (context, state, dynamic userInfo) {
                            return ListTile();
                          },
                        )
                      : Text(
                          'If you leave this off, your challenge will be sent to everybody.',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Schedule challenge',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 100,
                      ),
                      Builder(
                        builder: (context) => ToggleWidget(
                          value: scheduleValue,
                          onChanged: (value) => setState(() {
                            this.scheduleValue = value;
                          }),
                          sizeNumber: 1.5,
                          toggleNode: toggleNode,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ButtonWidget(
                    title: 'Post',
                    onClick: () {},
                    isButtonActive: isSubmit,
                    buttonColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
