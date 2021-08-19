import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gloou/screens/forget_password/reset_password_otp.dart';
import 'package:gloou/shared/api_environment/api_utils.dart';
import 'package:gloou/shared/models/forgetpasswordModel/resetpasswordModel.dart';
import 'package:gloou/shared/secure_storage/secure_storage.dart';
import 'package:gloou/widgets/button_widget.dart';
import 'package:gloou/widgets/onboarding_title_widget.dart';
import 'package:gloou/widgets/text_widget.dart';
import 'package:gloou/widgets/toast_widget.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:http/http.dart' as http;

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final resetPasswordFormKey = GlobalKey<FormState>();
  final emailOrPhoneController = TextEditingController();
  bool isSubmit = false;

  final SecureStorage secureStorage = SecureStorage();

  final FocusNode emailNode = FocusNode();

  late ResetpasswordModel resetpasswordModel;

  late String status;
  late String message;
  bool isError = false;

  final toast = FToast();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    toast.init(context);

    emailOrPhoneController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.close),
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: KeyboardDismisser(
        gestures: [GestureType.onTap],
        child: SafeArea(
            child: Center(
          child: Form(
            key: resetPasswordFormKey,
            child: ListView(
              padding: EdgeInsets.all(20),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OnboardingTitle(title: 'Reset your Password'),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 30,
                    ),
                    Text(
                      'Enter your Email address to reset your password',
                      style: TextStyle(
                        height: 2,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 0.7,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 20,
                    ),
                    TextWidget(
                      textInput: emailOrPhoneController,
                      textNode: emailNode,
                      labelTitle: 'Email or Phone number',
                      validationMsg: (value) {
                        if (value.isEmpty) {
                          return 'Please Enter Email or Phone Number';
                        } else {
                          return null;
                        }
                      },
                    ),
                    isKeyboard
                        ? SizedBox(
                            height: MediaQuery.of(context).size.height / 50,
                          )
                        : SizedBox(
                            height: MediaQuery.of(context).size.height / 2.5,
                          ),
                  ],
                ),
                ButtonWidget(
                  title: 'Continue',
                  isButtonActive: isSubmit,
                  onClick: () {
                    final currentState = resetPasswordFormKey.currentState;
                    final isValid;
                    if (currentState != null) {
                      isValid = currentState.validate();
                    } else {
                      isValid = false;
                    }
                    if (isValid) {
                      isSubmit = true;
                      onSubmit();
                    }
                  },
                ),
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
    resetpasswordModel = ResetpasswordModel(
      emailOrPhone: emailOrPhoneController.text,
    );
    var url = Uri.parse(ApiUtils.API_URL + '/User/PasswordReset/Start');
    var httpClient = http.Client();
    var response = await httpClient.post(
      url,
      body: jsonEncode(resetpasswordModel.toJson()),
      headers: Header.noBearerHeader,
    );
    if (response.statusCode == 200) {
      // var jsonResponse = jsonDecode(response.body);

      setState(() {
        secureStorage.writeSecureData(
          'emailOrPhone',
          emailOrPhoneController.text,
        );
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPasswordOtp(),
        ),
      );
    } else {
      var jsonError = jsonDecode(response.body);
      print(jsonError);

      setState(() {
        isSubmit = false;
        status = 'error';
        message = jsonError['error'];
        displayToast();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResetPasswordOtp(),
          ),
        );
      });
    }
  }
}
