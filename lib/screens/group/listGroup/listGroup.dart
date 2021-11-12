import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:gloou/screens/group/addGroup/addGroup.dart';
import 'package:gloou/screens/log_in/log_in.dart';
import 'package:gloou/shared/api_environment/api_utils.dart';
import 'package:gloou/shared/colors/colors.dart';
import 'package:gloou/shared/token/token.dart';
import 'package:gloou/shared/utilities/convert_image.dart';
import 'package:http/http.dart' as http;

class ListGroup extends StatefulWidget {
  const ListGroup({Key? key}) : super(key: key);

  @override
  _ListGroupState createState() => _ListGroupState();
}

class _ListGroupState extends State<ListGroup> {
  final TokenLogic tokenLogic = TokenLogic();
  final ConvertImage convertImage = ConvertImage();

  bool isCircular = true;

  List groups = [];

  fetchUserGroups() async {
    var token = await tokenLogic.getToken();
    if (token != null) {
      var url = Uri.parse(ApiUtils.API_URL + '/Group/GetByUserID');
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
        print(jsonDecode(response.body));
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserGroups().then((userGroup) {
      setState(() {
        if (userGroup != null) {
          var groupData = userGroup['data'];
          if (groupData.length > 0) {
            groups = groupData;
            isCircular = false;
          } else {
            isCircular = false;
          }
        } else {
          isCircular = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double size = 50;
    final left = size - 20;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Groups',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.close),
        ),
      ),
      floatingActionButton: groups.length > 0
          ? Bounce(
              child: Container(
                height: 64,
                width: 64,
                child: CircleAvatar(
                  child: Icon(
                    Icons.add,
                    size: 34,
                  ),
                ),
              ),
              duration: Duration(milliseconds: 500),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddGroup()),
                );
              },
            )
          : null,
      body: ListView(
        padding: EdgeInsets.all(15),
        children: [
          isCircular
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : groups.length > 0
                  ? Column(
                      children: [
                        Wrap(
                          children: List.generate(
                            groups.length,
                            (i) {
                              return Card(
                                elevation: 0.1,
                                color: textFeedColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            groups[i]['name'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          Bounce(
                                            child:
                                                Icon(Icons.more_horiz_rounded),
                                            duration:
                                                Duration(milliseconds: 500),
                                            onPressed: () {},
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        groups[i]['description'],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Stack(
                                        children: List.generate(
                                            groups[i]['members'].length > 4
                                                ? 5
                                                : groups[i]['members'].length,
                                            (j) {
                                          return Container(
                                            height: 50,
                                            width: 50,
                                            margin: EdgeInsets.only(
                                              left: left * j,
                                            ),
                                            child: ClipOval(
                                              child: Container(
                                                padding: EdgeInsets.all(2),
                                                color: Colors.white,
                                                child: CircleAvatar(
                                                  child: j == 4
                                                      ? Text(
                                                          '+ ${groups[i]['members'].length - 5}',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      : CircleAvatar(
                                                          backgroundImage:
                                                              MemoryImage(
                                                            convertImage
                                                                .formatBase64(groups[
                                                                            i][
                                                                        'members']
                                                                    [
                                                                    j]['image']),
                                                          ),
                                                        ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    )
                  : Column(
                      children: [
                        Center(
                          child: Text('No Group'),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 4,
                        ),
                        Text('Click Button to add Group'),
                        SizedBox(
                          height: 10,
                        ),
                        Bounce(
                          child: Container(
                            height: 64,
                            width: 64,
                            child: CircleAvatar(
                              child: Icon(
                                Icons.add,
                                size: 34,
                              ),
                            ),
                          ),
                          duration: Duration(milliseconds: 500),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddGroup()),
                            );
                          },
                        ),
                      ],
                    ),
        ],
      ),
    );
  }
}
