import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gloou/shared/api_environment/api_utils.dart';
import 'package:gloou/shared/models/userinfoModel/userModel.dart';
import 'package:gloou/shared/secure_storage/secure_storage.dart';
import 'package:gloou/shared/utilities/convert_image.dart';
import 'package:gloou/widgets/button_widget.dart';
import 'package:gloou/widgets/text_widget.dart';
import 'package:gloou/widgets/toast_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:http/http.dart' as http;

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
  String image = '';
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

  late String status, message, token;

  final toast = FToast();

  final SecureStorage secureStorage = SecureStorage();

  late UserModel userModel;
  final ConvertImage convertImage = ConvertImage();

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      // var convertToBase64 = convertImage.imageToBase64(File(image.path).readAsBytesSync());
      final imageTemp = convertImage.imageToBase64(
        File(image.path).readAsBytesSync(),
      );

      setState(() {
        this.image = imageTemp;
        imageController.text = imageTemp;
        Navigator.of(context).pop(context);
      });
    } on PlatformException catch (e) {
      print('Failed to pick image $e');
    }
  }

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

  void init() async {
    emailOrPhoneController.text = widget.emailOrPhone;
    nameController.text = widget.name;
    usernameController.text = widget.username;
    imageController.text = widget.image;
    token = await secureStorage.readSecureData('token');
  }

  @override
  void dispose() {
    emailOrPhoneController.dispose();
    nameController.dispose();
    usernameController.dispose();
    imageController.dispose();
    // TODO: implement dispose
    super.dispose();
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
                        InkWell(
                          child: Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: image != ''
                                    ? MemoryImage(
                                        convertImage.formatBase64(image),
                                      )
                                    : MemoryImage(
                                        convertImage.formatBase64(widget.image),
                                      ),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          onTap: showBottomSheet,
                        ),
                        Positioned(
                          child: InkWell(
                            child: Container(
                              width: 30,
                              height: 30,
                              child: Icon(
                                Icons.camera_alt_sharp,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            onTap: showBottomSheet,
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
                    title: 'Save Changes',
                    isButtonActive: isSubmit,
                    onClick: onSubmit,
                    buttonColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          )),
        ),
      ),
    );
  }

  void showBottomSheet() => showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(24),
            topLeft: Radius.circular(24),
          ),
        ),
        context: context,
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.image_outlined),
              title: Text('Gallery'),
              onTap: () => pickImage(ImageSource.gallery),
            ),
            ListTile(
              leading: Icon(Icons.camera_alt_outlined),
              title: Text('Camera'),
              onTap: () => pickImage(ImageSource.camera),
            ),
          ],
        ),
      );

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

    var url = Uri.parse(ApiUtils.API_URL + '/User/UpdateProfile');
    var httpClient = http.Client();

    var response = await httpClient.put(
      url,
      body: jsonEncode(userModel.toJson()),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      setState(() {
        Navigator.pop(context);
      });
    } else {}
  }
}
