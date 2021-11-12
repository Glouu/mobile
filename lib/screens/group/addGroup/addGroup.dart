import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gloou/shared/colors/colors.dart';
import 'package:gloou/shared/token/token.dart';
import 'package:gloou/shared/utilities/convert_image.dart';
import 'package:gloou/widgets/button_widget.dart';
import 'package:gloou/widgets/text_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class AddGroup extends StatefulWidget {
  const AddGroup({Key? key}) : super(key: key);

  @override
  _AddGroupState createState() => _AddGroupState();
}

class _AddGroupState extends State<AddGroup> {
  final createGroupFormKey = GlobalKey<FormState>();

  String image = '';
  TextEditingController imageController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final FocusNode imageNode = FocusNode();
  final FocusNode nameNode = FocusNode();
  final FocusNode descriptionNode = FocusNode();

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

  Future<bool?> showOption(BuildContext context) => showDialog<bool>(
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

  bool isSubmit = false;

  late String status, message, token;

  final toast = FToast();

  final TokenLogic tokenLogic = TokenLogic();
  final ConvertImage convertImage = ConvertImage();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imageController.addListener(() {
      setState(() {});
    });
    nameController.addListener(() {
      setState(() {});
    });
    descriptionController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    imageController.dispose();
    nameController.dispose();
    descriptionController.dispose();
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
          'Preference',
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
              key: createGroupFormKey,
              child: ListView(
                padding: EdgeInsets.all(20),
                physics: BouncingScrollPhysics(),
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        InkWell(
                          child: image != ''
                              ? Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: MemoryImage(
                                        convertImage.formatBase64(image),
                                      ),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                )
                              : ClipOval(
                                  child: Material(
                                    child: Container(
                                      width: 130,
                                      height: 130,
                                      padding: EdgeInsets.all(5),
                                      color: Colors.white,
                                      child: ClipOval(
                                        child: Container(
                                          width: 96,
                                          height: 96,
                                          padding: EdgeInsets.all(3),
                                          color: Color(0xFFc4c5ed),
                                          child: ClipOval(
                                            child: Container(
                                              width: 96,
                                              height: 96,
                                              color: Color(0xFFECEFFD),
                                            ),
                                          ),
                                        ),
                                      ),
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
                    textInput: nameController,
                    textNode: nameNode,
                    labelTitle: 'Name',
                    validationMsg: (value) {
                      if (value.isEmpty) {
                        return 'Please Group Name';
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 50,
                  ),
                  TextWidget(
                    textInput: descriptionController,
                    textNode: descriptionNode,
                    labelTitle: 'Description',
                    maxLines: 4,
                    validationMsg: (value) {
                      if (value.isEmpty) {
                        return 'Please Group Name';
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
          ),
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

  void onSubmit() async {
    FocusScope.of(context).requestFocus(FocusNode());
    final currentState = createGroupFormKey.currentState;
    final bool isValid;
    if (currentState != null) {
      isValid = currentState.validate();
    } else {
      isValid = false;
    }

    if (isValid) {
      isSubmit = true;
      print(
          'The Group Name is: ${nameController.text} & Group Description is: ${descriptionController.text} & Group image in base64 is: ${imageController.text}');
    }
  }
}
