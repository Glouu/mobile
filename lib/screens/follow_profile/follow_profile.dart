import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gloou/screens/log_in/log_in.dart';
import 'package:gloou/shared/api_environment/api_utils.dart';
import 'package:gloou/shared/token/token.dart';
import 'package:gloou/shared/utilities/convert_image.dart';
import 'package:gloou/widgets/button_widget.dart';
import 'package:http/http.dart' as http;

class FollowProfile extends StatefulWidget {
  final String userId;
  const FollowProfile({Key? key, required this.userId}) : super(key: key);

  @override
  _FollowProfileState createState() => _FollowProfileState();
}

class _FollowProfileState extends State<FollowProfile>
    with SingleTickerProviderStateMixin {
  final FocusNode toggleNode = FocusNode();
  late TabController _tabController;

  final ConvertImage convertImage = ConvertImage();
  final TokenLogic tokenLogic = TokenLogic();

  late Map<String, dynamic> userInfo;
  bool isCircular = true;

  List<Widget> children = [
    Container(
      child: Text(
        'Pictures Here',
        style: TextStyle(fontSize: 30),
      ),
    ),
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
  ];

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
    // TODO: implement initState
    super.initState();
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
                    'Visionary | Creator | Candle Maker | Aspiring nude photographer & Whatever else I feel like being ',
                    // userInfo['bio'],
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
                  ButtonWidget(
                    title: 'Follow',
                    onClick: () {},
                    isButtonActive: false,
                    buttonColor: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    child: Icon(Icons.mail_outline_rounded),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        width: 2,
                        color: Theme.of(context).primaryColor,
                      ),
                      padding: EdgeInsets.all(16),
                      shape: CircleBorder(),
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
                    children: children,
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
