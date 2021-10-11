import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gloou/screens/general_home/general_home.dart';
import 'package:gloou/shared/api_environment/api_utils.dart';
import 'package:gloou/shared/models/normalmediaModel/normalmediaModel.dart';
import 'package:gloou/shared/secure_storage/secure_storage.dart';
import 'package:gloou/shared/token/token.dart';
import 'package:gloou/widgets/button_widget.dart';
import 'package:gloou/widgets/text_media_widget.dart';
import 'package:gloou/widgets/toast_widget.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:http/http.dart' as http;

class DisplayPicture extends StatefulWidget {
  final String imagePath;
  const DisplayPicture({Key? key, required this.imagePath}) : super(key: key);

  @override
  _DisplayPictureState createState() => _DisplayPictureState();
}

class _DisplayPictureState extends State<DisplayPicture> {
  final postFormKey = GlobalKey<FormState>();

  TextEditingController captionController = TextEditingController();

  final FocusNode captionNode = FocusNode();
  final FocusNode toggleNode = FocusNode();

  bool isSubmit = false;
  bool challengeValue = false;
  bool scheduleValue = false;

  late NormalmediaModel _normalmediaModel;

  late String status, message;

  final toast = FToast();

  final SecureStorage secureStorage = SecureStorage();
  final TokenLogic tokenLogic = TokenLogic();

  late List followedUsers;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    toast.init(context);

    captionController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    captionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
          icon: Icon(Icons.close),
        ),
      ),
      body: Container(
        color: Colors.black,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: FileImage(File(widget.imagePath)),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      // bottomSheet: Container(),
      bottomNavigationBar: Stack(
        children: [
          Container(
            height: 70,
            color: Colors.black,
          ),
          Positioned(
            right: 20.0,
            top: 10,
            child: Container(
              child: ButtonWidget(
                title: 'Next',
                onClick: showSheet,
                isButtonActive: false,
                buttonColor: Theme.of(context).primaryColor,
              ),
            ),
          )
        ],
      ),
    );
  }

  showSheet() => showSlidingBottomSheet(
        context,
        builder: (context) => SlidingSheetDialog(
          snapSpec: SnapSpec(snappings: [0.7, 1]),
          builder: buildSheet,
        ),
      );

  Widget buildSheet(context, state) => StatefulBuilder(
        builder:
            (BuildContext context, void Function(void Function()) setState) {
          return Material(
            child: KeyboardDismisser(
              gestures: [GestureType.onTap],
              child: Form(
                key: postFormKey,
                child: ListView(
                  shrinkWrap: true,
                  primary: false,
                  padding: EdgeInsets.only(
                    left: 15,
                    right: 15,
                    bottom: 10,
                    top: 5,
                  ),
                  children: [
                    TextMediaWidget(
                      textInput: captionController,
                      textNode: captionNode,
                      maxLines: 4,
                      labelTitle: 'Caption',
                      validationMsg: (value) {},
                      prefix: Padding(
                        padding:
                            EdgeInsets.only(left: 10, right: 10, bottom: 5),
                        child: Container(
                          width: 50,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: FileImage(
                                File(widget.imagePath),
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ButtonWidget(
                      title: 'Post',
                      onClick: onSubmitNormal,
                      isButtonActive: isSubmit,
                      buttonColor: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );

  void displayToast() => toast.showToast(
        child: ToastMessage(status: status, message: message),
        gravity: ToastGravity.TOP,
      );

  void onSubmitNormal() async {
    var token = await tokenLogic.getToken();
    FocusScope.of(context).requestFocus(FocusNode());
    // final currentState = postFormKey.currentState;
    // final isValid;
    // if(currentState != null) {
    //   isValid = currentState.validate();
    // }else{
    //   isValid = false;
    // }

    _normalmediaModel = NormalmediaModel(
      caption: captionController.text,
      isText: false,
    );

    var captionUrl = Uri.parse(ApiUtils.API_URL + '/Post/Create');
    var httpClient = http.Client();
    var captionResponse = await httpClient.post(
      captionUrl,
      body: jsonEncode(_normalmediaModel.toJson()),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );
    if (captionResponse.statusCode == 200) {
      var captionJsonResponse = jsonDecode(captionResponse.body);
      var captionId = captionJsonResponse['data']['id'];

      var fileResponse = await addImage(captionId, widget.imagePath);
      if (fileResponse.statusCode == 200) {
        setState(() {
          status = 'success';
          message = 'Reload to see tou new post';
          displayToast();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GeneralHome()),
          );
        });
      } else {
        setState(() {
          status = 'error';
          message = 'Fail to upload file';
          displayToast();
        });
      }
    } else {
      var captionJsonError = jsonDecode(captionResponse.body);

      setState(() {
        isSubmit = false;
        status = 'error';
        message = captionJsonError['error'];
        displayToast();
      });
    }
  }

  Future<http.StreamedResponse> addImage(
    String captionId,
    String imagePath,
  ) async {
    var token = await tokenLogic.getToken();
    var fileUrl = Uri.parse(ApiUtils.API_URL + '/Post/SaveFile/$captionId');

    var fileRequest = http.MultipartRequest(
      'Put',
      fileUrl,
    );
    fileRequest.files.add(
      await http.MultipartFile.fromPath('file', imagePath),
    );
    fileRequest.headers.addAll({
      HttpHeaders.contentTypeHeader: 'multipart/form-data',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    });

    var fileResponse = fileRequest.send();

    return fileResponse;
  }
}
