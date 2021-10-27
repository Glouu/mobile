import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gloou/shared/api_environment/api_utils.dart';
import 'package:gloou/shared/secure_storage/secure_storage.dart';
import 'package:gloou/widgets/button_widget.dart';
import 'package:gloou/widgets/secure_input_widget.dart';
import 'package:gloou/widgets/toast_widget.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:http/http.dart' as http;

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final changePasswordFormKey = GlobalKey<FormState>();

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final retypePasswordController = TextEditingController();

  final FocusNode currentPasswordNode = FocusNode();
  final FocusNode newPasswordNode = FocusNode();
  final FocusNode retypePasswordNode = FocusNode();

  bool isSubmit = false;

  late String status, message;

  final toast = FToast();

  bool isCurrentPasswordVisible = true;
  bool isNewPasswordVisible = true;
  bool isRetypePasswordVisible = true;

  final SecureStorage secureStorage = SecureStorage();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    toast.init(context);

    currentPasswordController.addListener(() {
      setState(() {});
    });

    newPasswordController.addListener(() {
      setState(() {});
    });

    retypePasswordController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Change Password',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: KeyboardDismisser(
        gestures: [GestureType.onTap],
        child: SafeArea(
            child: Center(
          child: Form(
            key: changePasswordFormKey,
            child: ListView(
              padding: EdgeInsets.all(30),
              children: [
                SecureInputWidget(
                    textInput: currentPasswordController,
                    textNode: currentPasswordNode,
                    labelTitle: 'Current Password',
                    validationMsg: (value) {
                      if (value.isEmpty) {
                        return 'Please Enter Password';
                      } else {
                        return null;
                      }
                    },
                    isPasswordVisible: isCurrentPasswordVisible,
                    onClick: () {
                      setState(() {
                        isCurrentPasswordVisible = !isCurrentPasswordVisible;
                      });
                    }),
                SizedBox(
                  height: 5,
                ),
                SecureInputWidget(
                    textInput: newPasswordController,
                    textNode: newPasswordNode,
                    labelTitle: 'Current Password',
                    validationMsg: (value) {
                      if (value.isEmpty) {
                        return 'Please Enter Password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      } else {
                        return null;
                      }
                    },
                    isPasswordVisible: isNewPasswordVisible,
                    onClick: () {
                      setState(() {
                        isNewPasswordVisible = !isNewPasswordVisible;
                      });
                    }),
                SizedBox(
                  height: 5,
                ),
                SecureInputWidget(
                    textInput: retypePasswordController,
                    textNode: retypePasswordNode,
                    labelTitle: 'Current Password',
                    validationMsg: (value) {
                      if (value.isEmpty) {
                        return 'Please Enter Password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      } else if (value != newPasswordController.text) {
                        return 'It does not match the new password';
                      } else {
                        return null;
                      }
                    },
                    isPasswordVisible: isRetypePasswordVisible,
                    onClick: () {
                      setState(() {
                        isRetypePasswordVisible = !isRetypePasswordVisible;
                      });
                    }),
                isKeyboard
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height / 50,
                      )
                    : SizedBox(
                        height: MediaQuery.of(context).size.height / 2,
                      ),
                ButtonWidget(
                  title: 'Save Changes',
                  onClick: () {},
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

  void displayToast() => toast.showToast(
        child: ToastMessage(status: status, message: message),
        gravity: ToastGravity.TOP,
      );

  void onSubmit() async {
    FocusScope.of(context).requestFocus(FocusNode());
    final currentState = changePasswordFormKey.currentState;
    final isValid;
    if (currentState != null) {
      isValid = currentState.validate();
    } else {
      isValid = false;
    }
    // signupModel = SignupModel(
    //   emailOrPhone: emailOrPhoneController.text,
    //   password: passwordController.text,
    //   name: nameController.text,
    //   userName: usernameController.text,
    // );
    var url = Uri.parse(ApiUtils.API_URL + '');
    var httpClient = http.Client();
    var response = await httpClient.post(
      url,
      // body: jsonEncode(signupModel.toJson()),
      headers: Header.noBearerHeader,
    );
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      setState(() {});

      displayToast();
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
