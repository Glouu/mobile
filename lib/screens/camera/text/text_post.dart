import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gloou/screens/general_home/general_home.dart';
import 'package:gloou/shared/api_environment/api_utils.dart';
import 'package:gloou/shared/models/normalmediaModel/normalmediaModel.dart';
import 'package:gloou/shared/secure_storage/secure_storage.dart';
import 'package:gloou/shared/token/token.dart';
import 'package:gloou/widgets/button_widget.dart';
import 'package:gloou/widgets/ontap_text_widget.dart';
import 'package:gloou/widgets/text_post_widget.dart';
import 'package:gloou/widgets/toast_widget.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:http/http.dart' as http;
import 'package:sliding_sheet/sliding_sheet.dart';

class TextPost extends StatefulWidget {
  const TextPost({Key? key}) : super(key: key);

  @override
  _TextPostState createState() => _TextPostState();
}

class _TextPostState extends State<TextPost> {
  bool isSubmit = false;
  final postFormKey = GlobalKey<FormState>();
  final scheduleFormKey = GlobalKey<FormState>();

  TextEditingController captionController = TextEditingController();
  TextEditingController datePickedController = TextEditingController();
  TextEditingController timePickedController = TextEditingController();

  final FocusNode captionNode = FocusNode();
  final FocusNode datePickedNode = FocusNode();
  final FocusNode timePickedNode = FocusNode();

  late bool isDateSelected = false;
  late DateTime dateSelected;

  late bool isTimeSelected = false;
  late TimeOfDay timeSelected;

  late String status, message;

  final toast = FToast();

  final SecureStorage secureStorage = SecureStorage();
  final TokenLogic tokenLogic = TokenLogic();

  late NormalmediaModel _normalmediaModel;

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
    // final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
            onPressed: () {
              setState(() {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => GeneralHome()),
                  (route) => false,
                );
              });
            },
            icon: Icon(Icons.close)),
        actions: [
          Stack(
            children: [
              ButtonWidget(
                title: '    Post' + '               ',
                onClick: onSubmit,
                isButtonActive: isSubmit,
                buttonColor: Theme.of(context).primaryColor,
              ),
              Positioned(
                right: 0,
                bottom: 0,
                top: 0,
                child: PopupMenuButton(
                  onSelected: (value) {
                    showScheduleDialog();
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 10,
                  icon: Icon(
                    Icons.keyboard_arrow_down_sharp,
                    color: Colors.white,
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/calendar.svg',
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Schedule'),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: KeyboardDismisser(
        gestures: [GestureType.onTap],
        child: Container(
          height: (size.height) / 1,
          child: SafeArea(
            child: Form(
                key: postFormKey,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextPostWidget(
                    textInput: captionController,
                    textNode: captionNode,
                    labelTitle: 'Start Typing',
                    validationMsg: (value) {},
                    prefix: Padding(padding: EdgeInsets.all(0)),
                    maxLines: 10,
                    hint: 'Start Typing Here',
                  ),
                )),
          ),
        ),
      ),
    );
  }

  showScheduleDialog() => showSlidingBottomSheet(
        context,
        builder: (context) => SlidingSheetDialog(
          snapSpec: SnapSpec(snappings: [0.7, 1]),
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
                key: scheduleFormKey,
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
                    Center(
                        child: Text(
                      'Schedule Post',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                    SizedBox(
                      height: 10,
                    ),
                    OnTapTextWidget(
                      textInput: datePickedController,
                      textNode: datePickedNode,
                      labelTitle: 'Date',
                      tapAction: () => datePicker(context),
                      validationMsg: (value) {},
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    OnTapTextWidget(
                      textInput: timePickedController,
                      textNode: timePickedNode,
                      labelTitle: 'Time',
                      tapAction: () => timePicker(context),
                      validationMsg: (value) {},
                    ),
                    SizedBox(
                      height: 10,
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
    if (captionController.text.isNotEmpty) {
      isSubmit = true;
      var token = await tokenLogic.getToken();
      var isAllowComments =
          await secureStorage.readSecureData('isAllowComments');
      FocusScope.of(context).requestFocus(FocusNode());

      _normalmediaModel = NormalmediaModel(
        caption: captionController.text,
        isText: true,
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
        setState(() {
          status = 'success';
          message = 'Reload to see you new post';
          displayToast();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GeneralHome()),
          );
        });
      } else {
        var captionJsonError = jsonDecode(captionResponse.body);

        setState(() {
          isSubmit = false;
          status = 'error';
          message = captionJsonError['error'];
          displayToast();
        });
      }
    } else {
      setState(() {
        isSubmit = false;
        status = 'error';
        message = 'Enter Texts';
        displayToast();
      });
    }
  }
}
