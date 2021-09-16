import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gloou/screens/general_home/general_home.dart';
import 'package:gloou/shared/api_environment/api_utils.dart';
import 'package:gloou/shared/models/dateofbirthModel/dateofbirthModel.dart';
import 'package:gloou/shared/secure_storage/secure_storage.dart';
import 'package:gloou/widgets/button_widget.dart';
import 'package:gloou/widgets/info_card_widget.dart';
import 'package:gloou/widgets/onboarding_title_widget.dart';
import 'package:gloou/widgets/ontap_text_widget.dart';
import 'package:gloou/widgets/toast_widget.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:http/http.dart' as http;

class DateOfBirth extends StatefulWidget {
  const DateOfBirth({Key? key}) : super(key: key);

  @override
  _DateOfBirthState createState() => _DateOfBirthState();
}

class _DateOfBirthState extends State<DateOfBirth> {
  final dateOfBirthFormKey = GlobalKey<FormState>();
  final dateOfBirthController = TextEditingController();

  final FocusNode dateOfBirthNode = FocusNode();
  late bool isDateSelected = false;
  late DateTime dateSelected;
  late DateTime submittedDate;

  bool isSubmit = false;

  late DateofbirthModel dateofbirthModel;

  late String status, message, token;

  final toast = FToast();

  final SecureStorage secureStorage = SecureStorage();

  @override
  void initState() {
    init();
    // TODO: implement initState
    super.initState();
    toast.init(context);

    dateOfBirthController.addListener(() {
      setState(() {});
    });
  }

  init() async {
    token = await secureStorage.readSecureData('token');
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      body: KeyboardDismisser(
        gestures: [GestureType.onTap],
        child: SafeArea(
            child: Center(
          child: Form(
            key: dateOfBirthFormKey,
            child: ListView(
              padding: EdgeInsets.all(20),
              children: [
                OnboardingTitle(
                  title: 'Add your Birthday',
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 20,
                ),
                OnTapTextWidget(
                  textInput: dateOfBirthController,
                  textNode: dateOfBirthNode,
                  labelTitle: 'Date of Birth',
                  tapAction: () => datePicker(context),
                  validationMsg: (value) {},
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 50,
                ),
                InfoCardWidget(
                  title: 'Why do we need this?',
                  description:
                      'Providing your birthday improves the features you see, and helps us keep the community safe.',
                ),
                isKeyboard
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height / 50,
                      )
                    : SizedBox(
                        height: MediaQuery.of(context).size.height / 2,
                      ),
                ButtonWidget(
                  title: 'Continue',
                  onClick: () {
                    final currentState = dateOfBirthFormKey.currentState;
                    final isValid;
                    if (currentState != null) {
                      isValid = currentState.validate();
                    } else {
                      isValid = false;
                    }
                    if (isValid) {
                      // isSubmit = true;
                      onSubmit();
                    }
                  },
                  isButtonActive: isSubmit,
                  buttonColor: Theme.of(context).primaryColor,
                )
              ],
            ),
          ),
        )),
      ),
    );
  }

  Future datePicker(BuildContext context) async {
    final initialDate = DateTime.now();
    // final newDate = await
    showDatePicker(
      context: context,
      initialDate: isDateSelected ? dateSelected : initialDate,
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime.now(),
      helpText: 'Add your Birthday',
      cancelText: 'Close',
      confirmText: 'Confirm',
    ).then((selectedDate) {
      if (selectedDate != null) {
        setState(() {
          isDateSelected = true;
          dateSelected = selectedDate;
          final format = DateFormat('MM/dd/yyyy');
          dateOfBirthController.text = format.format(selectedDate);
          submittedDate = selectedDate;
        });
      }
    });
  }

  void displayToast() => toast.showToast(
        child: ToastMessage(status: status, message: message),
        gravity: ToastGravity.TOP,
      );

  void onSubmit() async {
    FocusScope.of(context).requestFocus(FocusNode());
    dateofbirthModel = DateofbirthModel(
      dateOfBirth: submittedDate.toIso8601String() + 'Z',
      // dateOfBirth: submittedDate.toString(),
    );
    var url = Uri.parse(ApiUtils.API_URL + '/User/UpdateDateOfBirth');
    var httpClient = http.Client();
    var response = await httpClient.put(
      url,
      body: jsonEncode(dateofbirthModel.toJson()),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      // var jsonResponse = jsonDecode(response.body);
      setState(() {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => GeneralHome(),
            ));
      });
    } else {
      var jsonError = jsonDecode(response.body);
      setState(() {
        isSubmit = false;
        status = 'error';
        message = jsonError['error'];
        displayToast();
      });
    }
  }
}
