import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gloou/screens/log_in/log_in.dart';
import 'package:gloou/shared/api_environment/api_utils.dart';
import 'package:gloou/shared/models/groupModel/addgroupmemberModel/addgroupmemberModel.dart';
import 'package:gloou/shared/token/token.dart';
import 'package:gloou/shared/utilities/convert_image.dart';
import 'package:gloou/widgets/toast_widget.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:http/http.dart' as http;

class ManageMember extends StatefulWidget {
  final String groupId;
  const ManageMember({
    Key? key,
    required this.groupId,
  }) : super(key: key);

  @override
  _ManageMemberState createState() => _ManageMemberState();
}

class _ManageMemberState extends State<ManageMember> {
  List usersDetails = [];

  final ConvertImage convertImage = ConvertImage();
  final TokenLogic tokenLogic = TokenLogic();
  final editGroupMemberFormKey = GlobalKey<FormState>();

  late AddgroupmemberModel _addgroupmemberModel;

  bool isSubmit = false;
  bool isCircular = true;

  late String status, message;

  final toast = FToast();

  init() async {
    var token = await tokenLogic.getToken();
    if (token != null) {
      var url = Uri.parse(ApiUtils.API_URL + '/User/GetUser');
      var httpClient = http.Client();
      var response = await httpClient.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        },
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        // var jsonError = jsonDecode(response.body);
      }
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => LogIn(),
        ),
        (route) => false,
      );
    }
  }

  getUsersData(String groupId) async {
    var token = await tokenLogic.getToken();
    if (token != null) {
      var url = Uri.parse(ApiUtils.API_URL + '/Group/GetMembers?id=$groupId');
      var httpClient = http.Client();
      var response = await httpClient.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        },
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        return result;
      } else {}
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => LogIn(),
        ),
        (route) => false,
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    toast.init(context);
    init().then((userData) {
      setState(() {
        getUsersData(widget.groupId).then((data) {
          setState(() {
            usersDetails = data['data'];
            isCircular = false;
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Manage Members',
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
              key: editGroupMemberFormKey,
              child: ListView(
                padding: EdgeInsets.all(15),
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  isCircular
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView(
                          shrinkWrap: true,
                          children: List.generate(usersDetails.length, (i) {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: MemoryImage(convertImage
                                    .formatBase64(usersDetails[i]['image'])),
                              ),
                              title: Text(
                                usersDetails[i]['firstName'] +
                                    ' ' +
                                    usersDetails[i]['lastName'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Text(usersDetails[i]['userName']),
                              trailing: OutlinedButton(
                                onPressed: isSubmit
                                    ? null
                                    : () {
                                        removeGroupMembers(
                                                usersDetails[i]['id'])
                                            .then((data) {
                                          usersDetails.removeWhere((group) =>
                                              group['id'] ==
                                              usersDetails[i]['id']);
                                        });
                                      },
                                child: isSubmit
                                    ? Container(
                                        height: 14,
                                        width: 14,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        'Remove',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    width: 2,
                                    color: Colors.red,
                                  ),
                                  padding: EdgeInsets.all(16),
                                  shape: StadiumBorder(),
                                ),
                              ),
                            );
                          }),
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

  removeGroupMembers(String userId) async {
    var token = await tokenLogic.getToken();
    FocusScope.of(context).requestFocus(FocusNode());
    final currentState = editGroupMemberFormKey.currentState;
    final bool isValid;
    if (currentState != null) {
      isValid = currentState.validate();
    } else {
      isValid = false;
    }

    if (isValid) {
      isSubmit = true;
      _addgroupmemberModel = AddgroupmemberModel(
        groupId: widget.groupId,
        userId: userId,
      );

      var url = Uri.parse(ApiUtils.API_URL + '/Group/RemoveMember');
      var httpClient = http.Client();

      var response = await httpClient.delete(
        url,
        body: jsonEncode(_addgroupmemberModel.toJson()),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          isSubmit = false;
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
}
