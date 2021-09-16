import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gloou/screens/log_in/log_in.dart';
import 'package:gloou/shared/api_environment/api_utils.dart';
import 'package:gloou/shared/models/forgetpasswordModel/newpasswordModel.dart';
import 'package:gloou/shared/secure_storage/secure_storage.dart';
import 'package:gloou/widgets/button_widget.dart';
import 'package:gloou/widgets/onboarding_title_widget.dart';
import 'package:gloou/widgets/secure_input_widget.dart';
import 'package:gloou/widgets/toast_widget.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:http/http.dart' as http;

class NewPassword extends StatefulWidget {
  const NewPassword({Key? key}) : super(key: key);

  @override
  _NewPasswordState createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  final newPasswordFormKey = GlobalKey<FormState>();

  final passwordController = TextEditingController();

  bool isSubmit = false;

  late NewpasswordModel newpasswordModel;

  bool value = false;

  late String status, message, emailOrPhone;

  final toast = FToast();

  bool isPasswordVisible = true;

  final SecureStorage secureStorage = SecureStorage();

  final FocusNode passwordNode = FocusNode();

  @override
  void initState() {
    init();
    // TODO: implement initState
    super.initState();

    toast.init(context);

    passwordController.addListener(() {
      setState(() {});
    });
  }

  init() async {
    emailOrPhone = await secureStorage.readSecureData('emailOrPhone');
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      body: KeyboardDismisser(
        gestures: [GestureType.onTap],
        child: SafeArea(
            child: Center(
          child: Form(
            key: newPasswordFormKey,
            child: ListView(
              padding: EdgeInsets.all(20),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 30,
                    ),
                    OnboardingTitle(
                      title: 'Create a New Password',
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 30,
                    ),
                    SecureInputWidget(
                      textInput: passwordController,
                      textNode: passwordNode,
                      labelTitle: 'Password',
                      validationMsg: (value) {
                        if (value.isEmpty) {
                          return 'Please Enter Your Password';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        } else {
                          return null;
                        }
                      },
                      isPasswordVisible: isPasswordVisible,
                      onClick: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                    isKeyboard
                        ? SizedBox(
                            height: MediaQuery.of(context).size.height / 20,
                          )
                        : SizedBox(
                            height: MediaQuery.of(context).size.height / 1.5,
                          ),
                  ],
                ),
                ButtonWidget(
                  title: 'Set Password',
                  isButtonActive: isSubmit,
                  onClick: () {
                    final isValid;
                    final currentState = newPasswordFormKey.currentState;
                    if (currentState != null) {
                      isValid = currentState.validate();
                    } else {
                      isValid = false;
                    }

                    print(isValid);

                    if (isValid) {
                      onSubmit();
                    }
                  },
                  buttonColor: Theme.of(context).primaryColor,
                )
              ],
            ),
          ),
        )),
      ),
    );
  }

  void displayToast() => toast.showToast(
        child: ToastMessage(status: status, message: message),
        gravity: ToastGravity.TOP,
      );

  void onSubmit() async {
    FocusScope.of(context).requestFocus(FocusNode());

    newpasswordModel = NewpasswordModel(
      emailOrPhone: emailOrPhone,
      password: passwordController.text,
    );
    print(newpasswordModel.toJson());

    var url = Uri.parse(ApiUtils.API_URL + '/User/PasswordReset/Update');
    var httpClient = http.Client();
    var response = await httpClient.put(
      url,
      body: jsonEncode(newpasswordModel.toJson()),
      headers: Header.noBearerHeader,
    );

    if (response.statusCode == 200) {
      // var jsonResponse = jsonDecode(response.body);

      setState(() {
        status = 'success';
        message = 'You can Move on now';

        displayToast();
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LogIn(),
        ),
      );
    } else {
      var jsonError = jsonDecode(response.body);

      setState(() {
        status = 'error';
        message = jsonError['error'];

        displayToast();

        print(jsonError);
      });
    }
  }
}
