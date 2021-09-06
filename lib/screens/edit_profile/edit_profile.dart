import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gloou/shared/models/userinfoModel/userModel.dart';
import 'package:gloou/shared/utilities/convert_image.dart';
import 'package:gloou/shared/utilities/sample_data.dart';
import 'package:gloou/widgets/button_widget.dart';
import 'package:gloou/widgets/text_widget.dart';
import 'package:gloou/widgets/toast_widget.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class EditProfile extends StatefulWidget {
  final String image, name, username, bio, emailOrPhone;
  const EditProfile({
    Key? key,
    required this.image,
    required this.name,
    required this.username,
    required this.bio,
    required this.emailOrPhone,
  }) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final editProfileFormKey = GlobalKey<FormState>();

  TextEditingController emailOrPhoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController imageController = TextEditingController();

  final FocusNode emailNode = FocusNode();
  final FocusNode nameNode = FocusNode();
  final FocusNode usernameNode = FocusNode();
  final FocusNode imagedNode = FocusNode();

  bool isSubmit = false;

  late String status;
  late String message;

  final toast = FToast();

  UserModel userModel = UserData.myData;
  final ConvertImage convertImage = ConvertImage();

  Future<bool?> showWarning(BuildContext context) => showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Discard Changes'),
          content: Text('Changes will not be saved.'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Discard'),
            ),
          ],
        ),
      );

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

    imageController.addListener(() {
      setState(() {});
    });

    init();
  }

  void init() {
    emailOrPhoneController.text = widget.emailOrPhone;
    nameController.text = widget.name;
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return WillPopScope(
      onWillPop: () async {
        final isEditPage = true;

        if (isEditPage) {
          final shouldPop = await showWarning(context);

          return shouldPop ?? false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            'Edit profile',
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        body: KeyboardDismisser(
          gestures: [GestureType.onTap],
          child: SafeArea(
              child: Center(
            child: Form(
              key: editProfileFormKey,
              child: ListView(
                padding: EdgeInsets.all(20),
                physics: BouncingScrollPhysics(),
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: MemoryImage(
                                convertImage.formatBase64(userModel.image),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          child: Container(
                            width: 30,
                            height: 30,
                            child: Icon(
                              Icons.camera_alt_sharp,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        )
                      ],
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
                  isKeyboard
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height / 50,
                        )
                      : SizedBox(
                          height: MediaQuery.of(context).size.height / 4,
                        ),
                  ButtonWidget(
                    title: 'Sign Up',
                    isButtonActive: isSubmit,
                    onClick: onSubmit,
                  ),
                ],
              ),
            ),
          )),
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
    final currentState = editProfileFormKey.currentState;
    final isValid;
    if (currentState != null) {
      isValid = currentState.validate();
    } else {
      isValid = false;
    }

    userModel = UserModel(
      bio: widget.bio,
      emailOrPhone: emailOrPhoneController.text,
      name: nameController.text,
      userName: usernameController.text,
      image: imageController.text,
    );
  }
}
