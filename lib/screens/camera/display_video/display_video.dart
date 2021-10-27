import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gloou/screens/general_home/general_home.dart';
import 'package:gloou/shared/api_environment/api_utils.dart';
import 'package:gloou/shared/models/normalmediaModel/normalmediaModel.dart';
import 'package:gloou/shared/models/storyModel/storyModel.dart';
import 'package:gloou/shared/secure_storage/secure_storage.dart';
import 'package:gloou/shared/token/token.dart';
import 'package:gloou/shared/utilities/video_compress_logic.dart';
import 'package:gloou/widgets/button_widget.dart';
import 'package:gloou/widgets/ontap_text_widget.dart';
import 'package:gloou/widgets/pick_username_chip_widget.dart';
import 'package:gloou/widgets/text_media_widget.dart';
import 'package:gloou/widgets/toast_widget.dart';
import 'package:gloou/widgets/toggle_widget.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

class DisplayVideo extends StatefulWidget {
  final String videoPath;
  final String platformName;
  const DisplayVideo({
    Key? key,
    required this.videoPath,
    required this.platformName,
  }) : super(key: key);

  @override
  _DisplayVideoState createState() => _DisplayVideoState();
}

class _DisplayVideoState extends State<DisplayVideo> {
  late VideoPlayerController _videoPlayerController;
  final postFormKey = GlobalKey<FormState>();

  TextEditingController captionController = TextEditingController();
  TextEditingController datePickedController = TextEditingController();
  TextEditingController timePickedController = TextEditingController();
  SheetController _sheetController = SheetController();

  final FocusNode captionNode = FocusNode();
  final FocusNode toggleNode = FocusNode();
  final FocusNode datePickedNode = FocusNode();
  final FocusNode timePickedNode = FocusNode();

  late bool isDateSelected = false;
  late DateTime dateSelected;

  late bool isTimeSelected = false;
  late TimeOfDay timeSelected;

  bool isSubmit = false;
  bool challengeValue = false;
  bool challengeScheduleValue = false;

  late NormalmediaModel _normalmediaModel;
  late StoryModel _storyModel;

  late String status, message;

  final toast = FToast();

  final SecureStorage secureStorage = SecureStorage();
  final TokenLogic tokenLogic = TokenLogic();

  late List followedUsers;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    toast.init(context);

    captionController.addListener(() {
      setState(() {});
    });

    datePickedController.addListener(() {
      setState(() {});
    });

    timePickedController.addListener(() {
      setState(() {});
    });
    _videoPlayerController = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {
          _videoPlayerController.play();
        });
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    captionController.dispose();
    datePickedController.dispose();
    timePickedController.dispose();
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
                title: widget.platformName == 'story' ? 'Post' : 'Next',
                onClick: () {
                  setState(() {
                    _videoPlayerController.pause();
                  });
                  widget.platformName == 'story'
                      ? onSubmitStoryVideo()
                      : showSheet();
                },
                isButtonActive: isSubmit,
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
          controller: _sheetController,
          cornerRadius: 15,
          avoidStatusBar: true,
          snapSpec: SnapSpec(
            snappings: [0.7, 1],
            initialSnap: 0.7,
          ),
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
                  widget.platformName == 'challenge'
                      ? Row(
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
                        )
                      : Container(),
                  widget.platformName == 'challenge'
                      ? challengeValue
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
                            )
                      : Container(),
                  SizedBox(
                    height: 10,
                  ),
                  widget.platformName == 'challenge'
                      ? Row(
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
                                value: challengeScheduleValue,
                                onChanged: (value) => setState(() {
                                  this.challengeScheduleValue = value;
                                }),
                                sizeNumber: 1.5,
                                toggleNode: toggleNode,
                              ),
                            )
                          ],
                        )
                      : Container(),
                  widget.platformName == 'normal'
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Schedule post',
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
                                value: challengeScheduleValue,
                                onChanged: (value) => setState(() {
                                  this.challengeScheduleValue = value;
                                }),
                                sizeNumber: 1.5,
                                toggleNode: toggleNode,
                              ),
                            )
                          ],
                        )
                      : Container(),
                  widget.platformName == 'bottled'
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Schedule bottle message',
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
                                value: challengeScheduleValue,
                                onChanged: (value) => setState(() {
                                  this.challengeScheduleValue = value;
                                }),
                                sizeNumber: 1.5,
                                toggleNode: toggleNode,
                              ),
                            )
                          ],
                        )
                      : Container(),
                  widget.platformName == 'timepod'
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Schedule TimePod',
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
                                value: challengeScheduleValue,
                                onChanged: (value) => setState(() {
                                  this.challengeScheduleValue = value;
                                }),
                                sizeNumber: 1.5,
                                toggleNode: toggleNode,
                              ),
                            )
                          ],
                        )
                      : Container(),
                  widget.platformName == 'challenge' ||
                          widget.platformName == 'normal' ||
                          widget.platformName == 'bottled' ||
                          widget.platformName == 'timepod'
                      ? SizedBox(
                          height: 10,
                        )
                      : Container(),
                  widget.platformName == 'challenge' ||
                          widget.platformName == 'normal' ||
                          widget.platformName == 'bottled' ||
                          widget.platformName == 'timepod'
                      ? challengeScheduleValue
                          ? OnTapTextWidget(
                              textInput: datePickedController,
                              textNode: datePickedNode,
                              labelTitle: 'Date',
                              tapAction: () => datePicker(context),
                              validationMsg: (value) {},
                            )
                          : Container()
                      : Container(),
                  widget.platformName == 'challenge' ||
                          widget.platformName == 'normal' ||
                          widget.platformName == 'bottled' ||
                          widget.platformName == 'timepod'
                      ? SizedBox(
                          height: 10,
                        )
                      : Container(),
                  widget.platformName == 'challenge' ||
                          widget.platformName == 'normal' ||
                          widget.platformName == 'bottled' ||
                          widget.platformName == 'timepod'
                      ? challengeScheduleValue
                          ? OnTapTextWidget(
                              textInput: timePickedController,
                              textNode: timePickedNode,
                              labelTitle: 'Time',
                              tapAction: () => timePicker(context),
                              validationMsg: (value) {},
                            )
                          : Container()
                      : Container(),
                  SizedBox(
                    height: 20,
                  ),
                  ButtonWidget(
                    title: 'Post',
                    onClick: onSubmitVideo,
                    isButtonActive: isSubmit,
                    buttonColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
        );
      });

  Future datePicker(BuildContext context) async {
    final initialDate = DateTime.now();

    showDatePicker(
      context: context,
      initialDate: isDateSelected ? dateSelected : initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    ).then((selectedDate) {
      if (selectedDate != null) {
        setState(() {
          isDateSelected = true;
          dateSelected = selectedDate;
          final format = DateFormat('MM/dd/yyyy');
          datePickedController.text = format.format(selectedDate);
        });
      }
    });
  }

  Future timePicker(BuildContext context) async {
    final initialTime = TimeOfDay.now();

    showTimePicker(
      context: context,
      initialTime: isTimeSelected ? timeSelected : initialTime,
    ).then((selectedTime) {
      if (selectedTime != null) {
        setState(() {
          isTimeSelected = true;
          timeSelected = selectedTime;
          final localizations = MaterialLocalizations.of(context);
          final formattedTime = localizations.formatTimeOfDay(timeSelected);
          timePickedController.text = formattedTime;

          // print(DateTime(dateSelected.year, dateSelected.month,
          //             dateSelected.day, selectedTime.hour, selectedTime.minute)
          //         .toIso8601String() +
          //     'Z');
        });
      }
    });
  }

  void displayToast() => toast.showToast(
        child: ToastMessage(status: status, message: message),
        gravity: ToastGravity.TOP,
      );

  void onSubmitVideo() async {
    isSubmit = true;
    _sheetController.rebuild();
    var token = await tokenLogic.getToken();
    var isAllowComments = await secureStorage.readSecureData('isAllowComments');
    FocusScope.of(context).requestFocus(FocusNode());

    _normalmediaModel = NormalmediaModel(
      caption: captionController.text,
      isText: false,
      allowComment: isAllowComments != null
          ? isAllowComments == 'true'
              ? true
              : false
          : true,
      type: widget.platformName,
      scheduledDate: isDateSelected
          ? isTimeSelected
              ? DateTime(
                    dateSelected.year,
                    dateSelected.month,
                    dateSelected.day,
                    timeSelected.hour,
                    timeSelected.minute,
                  ).toIso8601String() +
                  'Z'
              : DateTime(
                    dateSelected.year,
                    dateSelected.month,
                    dateSelected.day,
                  ).toIso8601String() +
                  'Z'
          : isTimeSelected
              ? DateTime(
                    timeSelected.hour,
                    timeSelected.minute,
                  ).toIso8601String() +
                  'Z'
              : '',
    );

    var captionUrl = Uri.parse(ApiUtils.API_URL + '/Post/Create');
    var httpClient = http.Client();
    var captionResponse = await httpClient.post(
      captionUrl,
      body: jsonEncode(_normalmediaModel.toJson()),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );
    if (captionResponse.statusCode == 200) {
      var captionJsonResponse = jsonDecode(captionResponse.body);
      var captionId = captionJsonResponse['data']['id'];

      final compressVideo = await VideoCompressLogic.compressVideo(
          File(widget.videoPath), context);
      if (compressVideo != null) {
        var fileResponse = await addPostVideo(
          captionId,
          compressVideo.path.toString(),
        );

        if (fileResponse.statusCode == 200) {
          setState(() {
            status = 'success';
            message = 'Reload to see tou new post';
            displayToast();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GeneralHome()),
            );
          });
        } else {
          setState(() {
            isSubmit = false;
            _sheetController.rebuild();
            status = 'error';
            message = 'Fail to upload file';
            displayToast();
          });
        }
      }
    } else {
      var captionJsonError = jsonDecode(captionResponse.body);

      setState(() {
        isSubmit = false;
        _sheetController.rebuild();
        status = 'error';
        message = captionJsonError['error'];
        displayToast();
      });
    }
  }

  void onSubmitStoryVideo() async {
    isSubmit = true;
    var token = await tokenLogic.getToken();
    var isAllowComments = await secureStorage.readSecureData('isAllowComments');
    FocusScope.of(context).requestFocus(FocusNode());

    _storyModel = StoryModel(
      caption: captionController.text,
      isText: false,
    );

    var captionUrl = Uri.parse(ApiUtils.API_URL + '/Story/Create');
    var httpClient = http.Client();
    var captionResponse = await httpClient.post(
      captionUrl,
      body: jsonEncode(_storyModel.toJson()),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );
    if (captionResponse.statusCode == 200) {
      var captionJsonResponse = jsonDecode(captionResponse.body);
      var captionId = captionJsonResponse['data']['id'];

      final compressVideo = await VideoCompressLogic.compressVideo(
          File(widget.videoPath), context);

      if (compressVideo != null) {
        var fileResponse = await addStoryVideo(
          captionId,
          compressVideo.path.toString(),
        );
        if (fileResponse.statusCode == 200) {
          setState(() {
            status = 'success';
            message = 'Reload to see tou new post';
            displayToast();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GeneralHome()),
            );
          });
        } else {
          setState(() {
            isSubmit = false;
            status = 'error';
            message = 'Fail to upload file';
            displayToast();
          });
        }
      }
    } else {
      var captionJsonError = jsonDecode(captionResponse.body);

      setState(() {
        isSubmit = false;
        status = 'error';
        message = captionJsonError['error'];
        displayToast();
      });
    }
  }

  Future<http.StreamedResponse> addPostVideo(
    String captionId,
    String videoPath,
  ) async {
    var token = await tokenLogic.getToken();
    var fileUrl = Uri.parse(ApiUtils.API_URL + '/Post/SaveFile/$captionId');

    var fileRequest = http.MultipartRequest(
      'Put',
      fileUrl,
    );
    fileRequest.files.add(
      await http.MultipartFile.fromPath('file', videoPath),
    );
    fileRequest.headers.addAll({
      HttpHeaders.contentTypeHeader: 'multipart/form-data',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    });

    var fileResponse = fileRequest.send();

    return fileResponse;
  }

  Future<http.StreamedResponse> addStoryVideo(
    String captionId,
    String videoPath,
  ) async {
    var token = await tokenLogic.getToken();
    var fileUrl = Uri.parse(ApiUtils.API_URL + '/Story/SaveFile/$captionId');

    var fileRequest = http.MultipartRequest(
      'Put',
      fileUrl,
    );
    fileRequest.files.add(
      await http.MultipartFile.fromPath('file', videoPath),
    );
    fileRequest.headers.addAll({
      HttpHeaders.contentTypeHeader: 'multipart/form-data',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    });

    var fileResponse = fileRequest.send();

    return fileResponse;
  }
}
