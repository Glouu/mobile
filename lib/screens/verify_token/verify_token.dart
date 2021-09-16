import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gloou/screens/date_of_birth/date_of_birth.dart';
import 'package:gloou/shared/api_environment/api_utils.dart';
import 'package:gloou/shared/models/otpModel/otpModel.dart';
import 'package:gloou/shared/models/otpModel/resendotpModel.dart';
import 'package:gloou/shared/models/signupModel/signupresponseModel/getsignupresponsemainModel.dart';
import 'package:gloou/shared/secure_storage/secure_storage.dart';
import 'package:gloou/widgets/button_widget.dart';
import 'package:gloou/widgets/light_button_widget.dart';
import 'package:gloou/widgets/number_widget.dart';
import 'package:gloou/widgets/onboarding_title_widget.dart';
import 'package:gloou/widgets/toast_widget.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:http/http.dart' as http;

class VerifyToken extends StatefulWidget {
  const VerifyToken({Key? key}) : super(key: key);

  @override
  _VerifyTokenState createState() => _VerifyTokenState();
}

class _VerifyTokenState extends State<VerifyToken> {
  final tokenFormKey = GlobalKey<FormState>();
  final resendKey = GlobalKey<FormState>();
  final tokenController = TextEditingController();
  bool isSubmit = false;
  late String subTitle;
  late String contact;
  late String id;

  late OtpModel otpModel;
  late ResendOtpModel resendotpModel;

  late GetsignupresponsemainModel getsignupresponsemainModel;

  final SecureStorage secureStorage = SecureStorage();

  final FocusNode tokenNode = FocusNode();

  late String status;
  late String message;

  final toast = FToast();

  @override
  void initState() {
    init();
    // TODO: implement initState
    super.initState();
    toast.init(context);

    tokenController.addListener(() {
      setState(() {});
    });
  }

  init() async {
    id = await secureStorage.readSecureData('id');
    if (await secureStorage.readSecureData('isEmail') == 'true') {
      contact = await secureStorage.readSecureData('email');
    } else {
      contact = await secureStorage.readSecureData('phoneNumber');
    }
    setState(() {
      subTitle =
          'Enter the OTP we sent to $contact to verify your GLOOU account.';
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
              key: tokenFormKey,
              child: ListView(
                padding: EdgeInsets.all(20),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OnboardingTitle(
                        title: 'Verify You Account',
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
                        textInput: tokenController,
                        textNode: tokenNode,
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
                          buttonKey: resendKey,
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
                    title: 'Continue',
                    isButtonActive: isSubmit,
                    onClick: () {
                      final isValid;
                      final currentState = tokenFormKey.currentState;
                      if (currentState != null) {
                        isValid = currentState.validate();
                      } else {
                        isValid = false;
                      }
                      if (isValid) {
                        onSubmitOtp();
                      }
                    },
                    buttonColor: Theme.of(context).primaryColor,
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
    resendotpModel = ResendOtpModel(id: id);
    var url = Uri.parse(ApiUtils.API_URL + '/User/ResendOTP');
    var httpClient = http.Client();
    var response = await httpClient.post(
      url,
      body: jsonEncode(resendotpModel.toJson()),
      headers: Header.noBearerHeader,
    );
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      setState(() {
        status = 'success';
        message = 'Lets Go';
        getsignupresponsemainModel =
            GetsignupresponsemainModel.fromJson(jsonResponse);

        secureStorage.writeSecureData(
          'id',
          getsignupresponsemainModel.data.id,
        );

        secureStorage.writeSecureData(
          'isEmail',
          getsignupresponsemainModel.data.isEmail.toString(),
        );
        if (getsignupresponsemainModel.data.isEmail == true) {
          secureStorage.writeSecureData(
            'email',
            getsignupresponsemainModel.data.email,
          );
        } else {
          secureStorage.writeSecureData(
            'phoneNumber',
            getsignupresponsemainModel.data.phoneNumber,
          );
        }
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

    otpModel = OtpModel(
      id: id,
      otp: tokenController.text,
    );

    var url = Uri.parse(ApiUtils.API_URL + '/User/ConfirmOTP');
    var httpClient = http.Client();
    var response = await httpClient.post(
      url,
      body: jsonEncode(otpModel.toJson()),
      headers: Header.noBearerHeader,
    );
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      setState(() {
        status = 'success';
        message = 'Welcome to Gloou';

        secureStorage.writeSecureData(
          'token',
          jsonResponse['data']['token'],
        );

        secureStorage.writeSecureData(
          'userId',
          jsonResponse['data']['user']['id'],
        );
      });

      displayToast();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DateOfBirth(),
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
