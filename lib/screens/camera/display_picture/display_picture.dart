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
import 'package:gloou/widgets/button_widget.dart';
import 'package:gloou/widgets/ontap_text_widget.dart';
import 'package:gloou/widgets/text_media_widget.dart';
import 'package:gloou/widgets/toast_widget.dart';
import 'package:gloou/widgets/toggle_widget.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:http/http.dart' as http;

class DisplayPicture extends StatefulWidget {
  final String imagePath;
  final String platformName;
  const DisplayPicture({
    Key? key,
    required this.imagePath,
    required this.platformName,
  }) : super(key: key);

  @override
  _DisplayPictureState createState() => _DisplayPictureState();
}

class _DisplayPictureState extends State<DisplayPicture> {
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
  bool scheduleValue = false;
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
                title: widget.platformName == 'story' ? 'Post' : 'Next',
                onClick:
                    widget.platformName == 'story' ? onSubmitStory : showSheet,
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

  Widget buildSheet(context, state) => StatefulBuilder(
        builder:
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
                    SizedBox(
                      height: 10,
                    ),
                    TextMediaWidget(
                      textInput: captionController,
                      textNode: captionNode,
                      maxLines: 4,
                      labelTitle: 'Caption',
                      validationMsg: (value) {},
                      prefix: Padding(
                        padding:
                            EdgeInsets.only(left: 10, right: 10, bottom: 5),
                        child: Container(
                          width: 50,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: FileImage(
                                File(widget.imagePath),
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
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
                    widget.platformName == 'normal' ||
                            widget.platformName == 'bottled'
                        ? SizedBox(
                            height: 10,
                          )
                        : Container(),
                    widget.platformName == 'normal' ||
                            widget.platformName == 'bottled'
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
                    widget.platformName == 'normal' ||
                            widget.platformName == 'bottled'
                        ? SizedBox(
                            height: 10,
                          )
                        : Container(),
                    widget.platformName == 'normal' ||
                            widget.platformName == 'bottled'
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
                      onClick: onSubmitNormal,
                      isButtonActive: isSubmit,
                      buttonColor: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );

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

  void onSubmitNormal() async {
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
      type: '',
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

      var fileResponse = await addPostImage(captionId, widget.imagePath);
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
    } else {
      var captionJsonError = jsonDecode(captionResponse.body);

      setState(() {
        isSubmit = false;
        _sheetController.rebuild();
        status = 'error';
        message = captionJsonError['error'];
        print(captionJsonError['error']);
        displayToast();
      });
    }
  }

  void onSubmitStory() async {
    isSubmit = true;
    var token = await tokenLogic.getToken();
    FocusScope.of(context).requestFocus(FocusNode());

    _storyModel = StoryModel(
      caption: captionController.text,
      isText: false,
    );

    var captionStoryUrl = Uri.parse(ApiUtils.API_URL + '/Story/Create');
    var httpClient = http.Client();
    var captionStoryResponse = await httpClient.post(
      captionStoryUrl,
      body: jsonEncode(_storyModel.toJson()),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );
    if (captionStoryResponse.statusCode == 200) {
      var captionStoryJsonResponse = jsonDecode(captionStoryResponse.body);
      var captionId = captionStoryJsonResponse['data']['id'];

      var fileResponse = await addStoryImage(captionId, widget.imagePath);
      if (fileResponse.statusCode == 200) {
        setState(() {
          status = 'success';
          message = 'Story added successfully';
          displayToast();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => GeneralHome()),
            (route) => false,
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
    } else {
      var captionStoryJsonError = jsonDecode(captionStoryResponse.body);

      setState(() {
        isSubmit = false;
        status = 'error';
        message = captionStoryJsonError['error'];
        displayToast();
      });
    }
  }

  Future<http.StreamedResponse> addPostImage(
    String captionId,
    String imagePath,
  ) async {
    var token = await tokenLogic.getToken();
    var fileUrl = Uri.parse(ApiUtils.API_URL + '/Post/SaveFile/$captionId');

    var fileRequest = http.MultipartRequest(
      'Put',
      fileUrl,
    );
    fileRequest.files.add(
      await http.MultipartFile.fromPath('file', imagePath),
    );
    fileRequest.headers.addAll({
      HttpHeaders.contentTypeHeader: 'multipart/form-data',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    });

    var fileResponse = fileRequest.send();

    return fileResponse;
  }

  Future<http.StreamedResponse> addStoryImage(
    String captionId,
    String imagePath,
  ) async {
    var token = await tokenLogic.getToken();
    var fileUrl = Uri.parse(ApiUtils.API_URL + '/Story/SaveFile/$captionId');

    var fileRequest = http.MultipartRequest(
      'Put',
      fileUrl,
    );
    fileRequest.files.add(
      await http.MultipartFile.fromPath('file', imagePath),
    );
    fileRequest.headers.addAll({
      HttpHeaders.contentTypeHeader: 'multipart/form-data',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    });

    var fileResponse = fileRequest.send();

    return fileResponse;
  }
}
