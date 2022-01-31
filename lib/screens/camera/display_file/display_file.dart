import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gloou/screens/general_home/general_home.dart';
import 'package:gloou/shared/api_environment/api_utils.dart';
import 'package:gloou/shared/models/normalmediaModel/normalmediaModel.dart';
import 'package:gloou/shared/secure_storage/secure_storage.dart';
import 'package:gloou/shared/token/token.dart';
import 'package:gloou/widgets/button_widget.dart';
import 'package:gloou/widgets/ontap_text_widget.dart';
import 'package:gloou/widgets/toast_widget.dart';
import 'package:gloou/widgets/toggle_widget.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:http/http.dart' as http;

class DisplayFile extends StatefulWidget {
  final String filePath;
  final String platformName;
  const DisplayFile({
    Key? key,
    required this.filePath,
    required this.platformName,
  }) : super(key: key);

  @override
  _DisplayFileState createState() => _DisplayFileState();
}

class _DisplayFileState extends State<DisplayFile> {
  final postFormKey = GlobalKey<FormState>();

  TextEditingController datePickedController = TextEditingController();
  TextEditingController timePickedController = TextEditingController();
  SheetController _sheetController = SheetController();

  final FocusNode toggleNode = FocusNode();
  final FocusNode datePickedNode = FocusNode();
  final FocusNode timePickedNode = FocusNode();

  late bool isDateSelected = false;
  late DateTime dateSelected;

  late bool isTimeSelected = false;
  late TimeOfDay timeSelected;

  late NormalmediaModel _normalmediaModel;

  bool isSubmit = false;
  bool scheduleValue = false;

  late String status, message;

  final toast = FToast();

  final SecureStorage secureStorage = SecureStorage();
  final TokenLogic tokenLogic = TokenLogic();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    toast.init(context);

    datePickedController.addListener(() {
      setState(() {});
    });

    timePickedController.addListener(() {
      setState(() {});
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: PDFView(
          filePath: widget.filePath,
        ),
      ),
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
                onClick: showSheet,
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
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 110,
                        width: 121,
                        child: PDFView(
                          filePath: widget.filePath,
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
                          'Schedule File',
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
                              _sheetController.expand();
                            }),
                            sizeNumber: 1.5,
                            toggleNode: toggleNode,
                          ),
                        )
                      ],
                    ),
                    scheduleValue
                        ? OnTapTextWidget(
                            textInput: datePickedController,
                            textNode: datePickedNode,
                            labelTitle: 'Date',
                            tapAction: () => datePicker(context),
                            validationMsg: (value) {},
                          )
                        : Container(),
                    scheduleValue
                        ? SizedBox(
                            height: 10,
                          )
                        : Container(),
                    scheduleValue
                        ? OnTapTextWidget(
                            textInput: timePickedController,
                            textNode: timePickedNode,
                            labelTitle: 'Time',
                            tapAction: () => timePicker(context),
                            validationMsg: (value) {},
                          )
                        : Container(),
                    SizedBox(
                      height: 30,
                    ),
                    ButtonWidget(
                      title: 'Post',
                      onClick: onSubmit,
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

  void onSubmit() async {
    setState(() {
      isSubmit = true;
      _sheetController.rebuild();
    });
    var token = await tokenLogic.getToken();
    var isAllowComments = await secureStorage.readSecureData('isAllowComments');
    FocusScope.of(context).requestFocus(FocusNode());

    _normalmediaModel = NormalmediaModel(
      caption: '',
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

      var fileResponse = await addPdf(captionId, widget.filePath);
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
          status = 'error';
          message = 'Fail to upload file';
          displayToast();
        });
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

  Future<http.StreamedResponse> addPdf(
    String captionId,
    String filePath,
  ) async {
    var token = await tokenLogic.getToken();
    var fileUrl = Uri.parse(ApiUtils.API_URL + '/Post/SaveFile/$captionId');

    var fileRequest = http.MultipartRequest(
      'Put',
      fileUrl,
    );
    fileRequest.files.add(
      await http.MultipartFile.fromPath('file', filePath),
    );
    fileRequest.headers.addAll({
      HttpHeaders.contentTypeHeader: 'multipart/form-data',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    });

    var fileResponse = await fileRequest.send();

    return fileResponse;
  }
}
