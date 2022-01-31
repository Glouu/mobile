import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gloou/screens/log_in/log_in.dart';
import 'package:gloou/shared/api_environment/api_utils.dart';
import 'package:gloou/shared/models/groupModel/addgroupmemberModel/addgroupmemberModel.dart';
import 'package:gloou/shared/token/token.dart';
import 'package:gloou/shared/utilities/convert_image.dart';
import 'package:gloou/widgets/button_widget.dart';
import 'package:gloou/widgets/toast_widget.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:http/http.dart' as http;

class GroupAddUsers extends StatefulWidget {
  final String groupId;
  const GroupAddUsers({
    Key? key,
    required this.groupId,
  }) : super(key: key);

  @override
  _GroupAddUsersState createState() => _GroupAddUsersState();
}

class _GroupAddUsersState extends State<GroupAddUsers> {
  List usersDetails = [];

  final ConvertImage convertImage = ConvertImage();
  final TokenLogic tokenLogic = TokenLogic();
  final addGroupMemberFormKey = GlobalKey<FormState>();
  final _chipKey = GlobalKey<ChipsInputState>();

  late AddgroupmemberModel _addgroupmemberModel;

  bool isSubmit = false;

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

  searchUser(String query) async {
    var token = await tokenLogic.getToken();
    if (token != null) {
      var url = Uri.parse(ApiUtils.API_URL + '/User/Search?query=$query');
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

  getUsersData(String userId) async {
    var token = await tokenLogic.getToken();
    if (token != null) {
      var url =
          Uri.parse(ApiUtils.API_URL + '/Profile/GetFollowers?userID=$userId');
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
        getUsersData(userData['data']['id']).then((data) {
          setState(() {
            usersDetails = data['data'];
          });
        });
      });
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
          'Invite People',
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
              key: addGroupMemberFormKey,
              child: ListView(
                padding: EdgeInsets.all(15),
                children: [
                  ChipsInput(
                    key: _chipKey,
                    allowChipEditing: true,
                    decoration: const InputDecoration(
                      hintText: 'Enter username or email',
                      prefixIcon: Icon(Icons.search),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF464BC8)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF464BC8)),
                      ),
                    ),
                    chipBuilder: (context, state, dynamic userInfo) {
                      return InputChip(
                        label: Text(userInfo['userName']),
                        onDeleted: () {
                          removeGroupMembers(userInfo['id']).then((data) {
                            state.deleteChip(userInfo);
                          });
                        },
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      );
                    },
                    suggestionBuilder: (context, state, dynamic userInfo) {
                      return SizedBox.shrink();
                    },
                    findSuggestions: (String query) {
                      if (query.length != 0) {
                        searchUser(query).then((data) {
                          setState(() {
                            if (data != null) {
                              if (data.length > 0) {
                                usersDetails = data['data'];
                              }
                            }
                          });
                        });
                        return usersDetails;
                        // return usersDetails.where((userInfo) {return }).toList(growable: false);
                      } else {
                        return usersDetails;
                      }
                    },
                    onChanged: (data) {
                      // print(data);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListView(
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
                                  addGroupMembers(usersDetails[i]['id'])
                                      .then((data) {
                                    _chipKey.currentState!
                                        .selectSuggestion(usersDetails[i]);
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
                                  'Add',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              width: 2,
                              color: Theme.of(context).primaryColor,
                            ),
                            padding: EdgeInsets.all(16),
                            shape: StadiumBorder(),
                          ),
                        ),
                      );
                    }),
                  ),
                  isKeyboard
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height / 50,
                        )
                      : SizedBox(
                          height: MediaQuery.of(context).size.height / 2,
                        ),
                  ButtonWidget(
                    title: 'Save Changes',
                    isButtonActive: isSubmit,
                    onClick: () {
                      Navigator.of(context).pop();
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

  addGroupMembers(String userId) async {
    var token = await tokenLogic.getToken();
    FocusScope.of(context).requestFocus(FocusNode());
    final currentState = addGroupMemberFormKey.currentState;
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

      var url = Uri.parse(ApiUtils.API_URL + '/Group/AddMember');
      var httpClient = http.Client();

      var response = await httpClient.post(
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

  removeGroupMembers(String userId) async {
    var token = await tokenLogic.getToken();
    FocusScope.of(context).requestFocus(FocusNode());
    final currentState = addGroupMemberFormKey.currentState;
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
