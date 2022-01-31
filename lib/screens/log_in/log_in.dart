import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gloou/screens/date_of_birth/date_of_birth.dart';
import 'package:gloou/screens/forget_password/reset_password.dart';
import 'package:gloou/screens/general_home/general_home.dart';
import 'package:gloou/screens/sign_up/sign_up.dart';
import 'package:gloou/screens/verify_token/verify_token.dart';
import 'package:gloou/shared/api_environment/api_utils.dart';
import 'package:gloou/shared/models/loginModel/loginModel.dart';
import 'package:gloou/shared/secure_storage/secure_storage.dart';
import 'package:gloou/widgets/button_widget.dart';
import 'package:gloou/widgets/onboarding_title_widget.dart';
import 'package:gloou/widgets/secure_input_widget.dart';
import 'package:gloou/widgets/text_button_widget.dart';
import 'package:gloou/widgets/text_widget.dart';
import 'package:gloou/widgets/toast_widget.dart';
import 'package:gloou/widgets/toggle_widget.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:http/http.dart' as http;

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final logInFormKey = GlobalKey<FormState>();

  final emailOrPhoneController = TextEditingController();
  final passwordController = TextEditingController();

  bool isSubmit = false;

  late LoginModel loginModel;
  bool value = false;

  late String status, message;

  final toast = FToast();

  bool isPasswordVisible = true;

  final SecureStorage secureStorage = SecureStorage();

  final FocusNode emailNode = FocusNode();
  final FocusNode passwordNode = FocusNode();
  final FocusNode toggleNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    toast.init(context);

    emailOrPhoneController.addListener(() {
      setState(() {});
    });

    passwordController.addListener(() {
      setState(() {});
    });
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
              key: logInFormKey,
              child: ListView(
                padding: EdgeInsets.all(30),
                children: [
                  OnboardingTitle(
                    title: 'Welcome Back 👋',
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 20,
                  ),
                  TextWidget(
                    textInput: emailOrPhoneController,
                    textNode: emailNode,
                    labelTitle: 'Email or Phone Number',
                    validationMsg: (value) {
                      if (value.isEmpty) {
                        return 'Please Enter Email or Phone Number';
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 50,
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
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 50,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ToggleWidget(
                        value: value,
                        sizeNumber: 1.5,
                        toggleNode: toggleNode,
                        onChanged: (value) =>
                            setState(() => this.value = value),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        'Remember Me',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      TextButtonWidget(
                        title: 'Forgot Password?',
                        onClick: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResetPassword(),
                            ),
                          );
                        },
                        fontSize: 15,
                      ),
                    ],
                  ),
                  isKeyboard
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height / 50,
                        )
                      : SizedBox(
                          height: MediaQuery.of(context).size.height / 3,
                        ),
                  ButtonWidget(
                    title: 'Login',
                    onClick: onSubmit,
                    isButtonActive: isSubmit,
                    buttonColor: Theme.of(context).primaryColor,
                  ),
                  TextButtonWidget(
                    title: 'I don’t have an account',
                    onClick: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUp(),
                        ),
                      );
                    },
                    fontSize: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void displayToast() => toast.showToast(
        child: ToastMessage(status: status, message: message),
        gravity: ToastGravity.TOP,
      );

  void onSubmit() async {
    FocusScope.of(context).requestFocus(FocusNode());
    final currentState = logInFormKey.currentState;
    final isValid;
    if (currentState != null) {
      isValid = currentState.validate();
    } else {
      isValid = false;
    }
    isSubmit = true;
    if (isValid) {
      loginModel = LoginModel(
        emailOrPhone: emailOrPhoneController.text.trim(),
        password: passwordController.text.trim(),
      );
      var url = Uri.parse(ApiUtils.API_URL + '/auth');
      var httpClient = http.Client();
      var response = await httpClient.post(
        url,
        body: jsonEncode(loginModel.toJson()),
        headers: Header.noBearerHeader,
      );

      if (response.statusCode == 200) {
        isSubmit = false;
        var jsonResponse = jsonDecode(response.body);

        setState(() {
          if (jsonResponse['data']['user']['isOtpVerified'] != true) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => VerifyToken(),
              ),
            );
          } else if (jsonResponse['data']['user']['dateOfBirth'] == null) {
            isSubmit = false;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DateOfBirth(),
              ),
            );
          } else {
            status = 'success';
            message = 'Enjoy Your Game';
          }
          secureStorage.writeSecureData(
            'token',
            jsonResponse['data']['token'],
          );
          secureStorage.writeSecureData(
            'userId',
            jsonResponse['data']['user']['id'],
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => GeneralHome(),
            ),
          );
        });
        displayToast();
      } else {
        var jsonError = jsonDecode(response.body);
        isSubmit = false;
        status = 'error';
        message = jsonError['error'];
        displayToast();
      }
    }
  }
}
