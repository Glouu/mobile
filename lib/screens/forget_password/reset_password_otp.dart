import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gloou/screens/forget_password/new_password.dart';
import 'package:gloou/shared/api_environment/api_utils.dart';
import 'package:gloou/shared/models/forgetpasswordModel/resetpasswordModel.dart';
import 'package:gloou/shared/models/forgetpasswordModel/resetpasswordotpModel.dart';
import 'package:gloou/shared/secure_storage/secure_storage.dart';
import 'package:gloou/widgets/button_widget.dart';
import 'package:gloou/widgets/light_button_widget.dart';
import 'package:gloou/widgets/number_widget.dart';
import 'package:gloou/widgets/onboarding_title_widget.dart';
import 'package:gloou/widgets/toast_widget.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:http/http.dart' as http;

class ResetPasswordOtp extends StatefulWidget {
  const ResetPasswordOtp({Key? key}) : super(key: key);

  @override
  _ResetPasswordOtpState createState() => _ResetPasswordOtpState();
}

class _ResetPasswordOtpState extends State<ResetPasswordOtp> {
  final resetPasswordOtpFormKey = GlobalKey<FormState>();
  final resendPasswordOtpKey = GlobalKey<FormState>();
  final otpController = TextEditingController();
  bool isSubmit = false;

  final SecureStorage secureStorage = SecureStorage();

  final FocusNode otpNode = FocusNode();

  late ResetpasswordotpModel resetpasswordotpModel;

  late ResetpasswordModel resetpasswordModel;

  late String status;
  late String message;
  late String subTitle;
  late String emailOrPhone;

  final toast = FToast();

  @override
  void initState() {
    init();
    // TODO: implement initState
    super.initState();
    toast.init(context);

    otpController.addListener(() {
      setState(() {});
    });
  }

  init() async {
    emailOrPhone = await secureStorage.readSecureData('emailOrPhone');
    setState(() {
      subTitle =
          'Enter the OTP we sent to $emailOrPhone to reset your password.';
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
              key: resetPasswordOtpFormKey,
              child: ListView(
                padding: EdgeInsets.all(20),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OnboardingTitle(
                        title: 'Reset your Password',
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 30,
                      ),
                      Text(
                        subTitle,
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
                      NumberWidget(
                        textInput: otpController,
                        textNode: otpNode,
                        numberMax: 4,
                        labelTitle: 'One-time code',
                        validationMsg: (value) {
                          if (value.isEmpty) {
                            return 'Please enter OTP';
                          } else if (value.length < 4) {
                            return 'Enter complete token';
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 50,
                      ),
                      Center(
                        child: LightButtonWidget(
                          buttonKey: resendPasswordOtpKey,
                          title: 'Resend code',
                          onClick: () {
                            onResendOtp();
                          },
                          isButtonActive: true,
                        ),
                      ),
                      isKeyboard
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height / 50,
                            )
                          : SizedBox(
                              height: MediaQuery.of(context).size.height / 3,
                            ),
                    ],
                  ),
                  ButtonWidget(
                    title: 'Reset',
                    isButtonActive: isSubmit,
                    onClick: () {
                      final isValid;
                      final currentState = resetPasswordOtpFormKey.currentState;
                      if (currentState != null) {
                        isValid = currentState.validate();
                      } else {
                        isValid = false;
                      }
                      if (isValid) {
                        onSubmitOtp();
                      }
                    },
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

  void onResendOtp() async {
    FocusScope.of(context).requestFocus(FocusNode());
    resetpasswordModel = ResetpasswordModel(
      emailOrPhone: emailOrPhone,
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
        status = 'success';
        message = 'OTP sent to $emailOrPhone';
      });

      displayToast();
    } else {
      var jsonError = jsonDecode(response.body);

      setState(() {
        status = 'error';
        message = jsonError['error'];
        displayToast();
      });
    }
  }

  void onSubmitOtp() async {
    FocusScope.of(context).requestFocus(FocusNode());

    resetpasswordotpModel = ResetpasswordotpModel(
      emailOrPhone: emailOrPhone,
      otp: otpController.text,
    );

    var url = Uri.parse(ApiUtils.API_URL + '/User/PasswordReset/VerifyOTP');
    var httpClient = http.Client();
    var response = await httpClient.post(
      url,
      body: jsonEncode(resetpasswordotpModel.toJson()),
      headers: Header.noBearerHeader,
    );
    if (response.statusCode == 200) {
      // var jsonResponse = jsonDecode(response.body);

      setState(() {
        status = 'success';
        message = 'You are doing well';

        displayToast();
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NewPassword(),
        ),
      );
    } else {
      var jsonError = jsonDecode(response.body);

      setState(() {
        status = 'error';
        message = jsonError['error'];
        displayToast();
      });
    }
  }
}
