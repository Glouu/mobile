import 'package:flutter/material.dart';
import 'package:gloou/widgets/button_widget.dart';
import 'package:gloou/widgets/number_widget.dart';
import 'package:gloou/widgets/onboarding_title_widget.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class VerifyToken extends StatefulWidget {
  const VerifyToken({Key? key}) : super(key: key);

  @override
  _VerifyTokenState createState() => _VerifyTokenState();
}

class _VerifyTokenState extends State<VerifyToken> {
  final tokenFormKey = GlobalKey<FormState>();
  final tokenController = TextEditingController();
  late final bool isValid;
  final bool isButtonEnabled = false;

  final FocusNode tokenNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tokenController.addListener(() {
      setState(() {});
    });

    setState(() {});
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
                padding: EdgeInsets.all(30),
                children: [
                  OnboardingTitle(
                    title: 'Verify You Account',
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 20,
                  ),
                  NumberWidget(
                    textInput: tokenController,
                    textNode: tokenNode,
                    numberMax: 4,
                    labelTitle: 'One-time code',
                    validationMsg: 'Enter complete token',
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
                    onClick: isButtonEnabled
                        ? () {
                            print(tokenController.text);
                            isValid = tokenFormKey.currentState!.validate();
                            print(isValid);
                            if (isValid) {
                              final otp = 'OTP: ${tokenController.text}';
                              final snackBar = SnackBar(
                                content: Text(
                                  otp,
                                  style: TextStyle(fontSize: 20),
                                ),
                                backgroundColor: Colors.purple,
                                duration: Duration(milliseconds: 500),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          }
                        : () {
                            print('no message');
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
}
