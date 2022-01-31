import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gloou/shared/api_environment/api_utils.dart';
import 'package:gloou/shared/models/groupModel/editgroupModel/editgroupModel.dart';
import 'package:gloou/shared/token/token.dart';
import 'package:gloou/shared/utilities/convert_image.dart';
import 'package:gloou/widgets/button_widget.dart';
import 'package:gloou/widgets/text_widget.dart';
import 'package:gloou/widgets/toast_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:http/http.dart' as http;

class EditGroup extends StatefulWidget {
  final String groupId;
  final String image;
  final String name;
  final String description;
  const EditGroup({
    Key? key,
    required this.groupId,
    required this.image,
    required this.name,
    required this.description,
  }) : super(key: key);

  @override
  _EditGroupState createState() => _EditGroupState();
}

class _EditGroupState extends State<EditGroup> {
  final editGroupFormKey = GlobalKey<FormState>();

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

  late String status, message;

  final toast = FToast();

  late EditgroupModel _editgroupModel;
  final TokenLogic tokenLogic = TokenLogic();
  final ConvertImage convertImage = ConvertImage();

  void init() async {
    imageController.text = widget.image;
    nameController.text = widget.name;
    descriptionController.text = widget.description;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    toast.init(context);
    imageController.addListener(() {
      setState(() {});
    });
    nameController.addListener(() {
      setState(() {});
    });
    descriptionController.addListener(() {
      setState(() {});
    });

    init();
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
          'Edit Group',
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
              key: editGroupFormKey,
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
                              : widget.image != ''
                                  ? Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: MemoryImage(
                                            convertImage
                                                .formatBase64(widget.image),
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

  void displayToast() => toast.showToast(
        child: ToastMessage(status: status, message: message),
        gravity: ToastGravity.TOP,
      );

  void onSubmit() async {
    isSubmit = true;
    var token = await tokenLogic.getToken();
    FocusScope.of(context).requestFocus(FocusNode());
    final currentState = editGroupFormKey.currentState;
    final isValid;
    if (currentState != null) {
      isValid = currentState.validate();
    } else {
      isValid = false;
    }

    _editgroupModel = EditgroupModel(
      id: widget.groupId,
      description: descriptionController.text,
      image: imageController.text,
      name: nameController.text,
    );

    var url = Uri.parse(ApiUtils.API_URL + '/Group/Update');
    var httpClient = http.Client();

    var response = await httpClient.put(
      url,
      body: jsonEncode(_editgroupModel.toJson()),
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
    } else {
      var jsonError = jsonDecode(response.body);
      isSubmit = false;
      status = 'error';
      message = jsonError['error'];
      displayToast();
    }
  }
}
