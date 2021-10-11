import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gloou/screens/edit_profile/edit_profile.dart';
import 'package:gloou/screens/log_in/log_in.dart';
import 'package:gloou/screens/profile/listOfUserPost/listOfUserPost.dart';
import 'package:gloou/shared/api_environment/api_utils.dart';
import 'package:gloou/shared/token/token.dart';
import 'package:gloou/shared/utilities/convert_image.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  final FocusNode toggleNode = FocusNode();
  late TabController _tabController;

  final ConvertImage convertImage = ConvertImage();
  final TokenLogic tokenLogic = TokenLogic();

  late Map<String, dynamic> userInfo;
  bool isCircular = true;

  bool isPostCircular = true;
  bool isChallengeCircular = true;
  bool isBMessageCircular = true;
  bool isTimeCircular = true;

  late bool isPostEmpty;
  late bool isChallengeEmpty;
  late bool isBMessageEmpty;
  late bool isTimePodEmpty;

  late List postData;

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

  fetchPost({int page = 1, int limit = 10}) async {
    var token = await tokenLogic.getToken();
    if (token != null) {
      var url = Uri.parse(ApiUtils.API_URL + '/Post/GetUserPosts');
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

  _onRefresh() async {
    var list = await fetchPost(page: 1);
    var listData = list['data'];
  }

  _onLoading() async {}

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    init().then((data) {
      setState(() {
        userInfo = data['data'];
        isCircular = false;
      });
    });
    fetchPost().then((data) {
      setState(() {
        var initialData = data['data'];
        if (data != null) {
          if (initialData.length > 0) {
            postData = initialData;
            isPostEmpty = false;
            isPostCircular = false;
          } else {
            isPostEmpty = true;
            isPostCircular = false;
          }
        } else {
          isPostEmpty = true;
          isPostCircular = false;
        }
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    init().then((data) {
      setState(() {
        userInfo = data['data'];
        isCircular = false;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isCircular
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(20),
            physics: BouncingScrollPhysics(),
            children: [
              Container(
                width: 100,
                height: 100,
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: MemoryImage(
                        convertImage.formatBase64(userInfo['image']),
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Column(
                children: [
                  Text(
                    userInfo['firstName'] + ' ' + userInfo['lastName'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    '@' + userInfo['userName'],
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildNumber(
                    context,
                    '435',
                    'Feed',
                  ),
                  buildNumber(
                    context,
                    '101k',
                    'Followers',
                  ),
                  buildNumber(
                    context,
                    '75k',
                    'Following',
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(userInfo['bio']),
                  Text(
                    userInfo['bio'],
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfile(
                            name: userInfo['firstName'] +
                                ' ' +
                                userInfo['lastName'],
                            image: userInfo['image'],
                            bio: userInfo['bio'],
                            username: userInfo['userName'],
                            emailOrPhone: userInfo['phoneNumber'] != ''
                                ? userInfo['phoneNumber']
                                : userInfo['email'],
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Edit profile',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Fellix-Bold',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        width: 2,
                        color: Theme.of(context).primaryColor,
                      ),
                      padding: EdgeInsets.all(16),
                      shape: StadiumBorder(),
                    ),
                  )
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                // height: MediaQuery.of(context).size.height,
                child: Scaffold(
                  appBar: AppBar(
                    toolbarHeight: 20,
                    centerTitle: true,
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    leading: null,
                    iconTheme: IconThemeData(color: Colors.black),
                    bottom: TabBar(
                      indicatorColor: Colors.transparent,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey[500],
                      controller: _tabController,
                      tabs: [
                        Tab(
                          icon: Icon(Icons.window_rounded),
                        ),
                        Tab(
                          icon: Icon(Icons.play_circle),
                        ),
                        Tab(
                          icon: Icon(Icons.hourglass_empty),
                        ),
                        Tab(
                          icon: Icon(Icons.book_outlined),
                        ),
                      ],
                    ),
                  ),
                  body: TabBarView(
                    controller: _tabController,
                    children: [
                      isPostCircular
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : isPostEmpty
                              ? Center(
                                  child: Text('You don\'t have any post'),
                                )
                              : ListOfUserPost(postData: postData),
                      Container(
                        child: Text(
                          'Videos Here',
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                      Container(
                        child: Text(
                          'Time pod here',
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                      Container(
                        child: Text(
                          'Pdf Here',
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
  }

  Widget buildNumber(BuildContext context, String value, String text) {
    return MaterialButton(
      onPressed: () {},
      padding: EdgeInsets.symmetric(vertical: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          )
        ],
      ),
    );
  }
}
