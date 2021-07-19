import 'package:flutter/material.dart';
import 'package:gloou/screens/verify_token/verify_token.dart';
import 'package:gloou/widgets/button_widget.dart';
import 'package:gloou/widgets/onboarding_title_widget.dart';
import 'package:gloou/widgets/secure_input_widget.dart';
import 'package:gloou/widgets/text_button_widget.dart';
import 'package:gloou/widgets/text_widget.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final signUpFormKey = GlobalKey<FormState>();
  final emailOrPhoneController = TextEditingController();
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordVisible = true;

  final FocusNode emailNode = FocusNode();
  final FocusNode nameNode = FocusNode();
  final FocusNode usernameNode = FocusNode();
  final FocusNode passwordNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    emailOrPhoneController.addListener(() {
      setState(() {});
    });

    nameController.addListener(() {
      setState(() {});
    });

    usernameController.addListener(() {
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
              key: signUpFormKey,
              child: ListView(
                padding: EdgeInsets.all(30),
                children: [
                  OnboardingTitle(
                    title: 'Create an Account',
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 20,
                  ),
                  TextWidget(
                    textInput: emailOrPhoneController,
                    textNode: emailNode,
                    labelTitle: 'Email or Phone number',
                    validationMsg: (value) {
                      final pattern =
                          r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
                      final regExp = RegExp(pattern);
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
                  TextWidget(
                    textInput: nameController,
                    textNode: nameNode,
                    labelTitle: 'Name',
                    validationMsg: (value) {
                      if (value.isEmpty) {
                        return 'Please Enter Name';
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 50,
                  ),
                  TextWidget(
                    textInput: usernameController,
                    textNode: usernameNode,
                    labelTitle: 'Username',
                    validationMsg: (value) {
                      if (value.isEmpty) {
                        return 'Please Enter Username';
                      } else if (value.length < 4) {
                        return 'Username can not be less than 4 characters';
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
                      isPasswordVisible: isPasswordVisible,
                      validationMsg: (value) {
                        if (value.isEmpty) {
                          return 'Please Enter Password';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        } else {
                          return null;
                        }
                      },
                      onClick: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      }),
                  isKeyboard
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height / 50,
                        )
                      : SizedBox(
                          height: MediaQuery.of(context).size.height / 4,
                        ),
                  ButtonWidget(
                    title: 'Sign Up',
                    onClick: () {
                      FocusScope.of(context).requestFocus(FocusNode());

                      final isValid = signUpFormKey.currentState!.validate();

                      if (isValid) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VerifyToken()),
                        );
                      }
                    },
                  ),
                  TextButtonWidget(
                    title: 'I have an account',
                    onClick: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
