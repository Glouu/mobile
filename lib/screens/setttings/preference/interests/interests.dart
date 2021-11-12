import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gloou/screens/log_in/log_in.dart';
import 'package:gloou/shared/api_environment/api_utils.dart';
import 'package:gloou/shared/models/interestModel/addinterestModel/addinterestModel.dart';
import 'package:gloou/shared/models/interestModel/interestModel.dart';
import 'package:gloou/shared/token/token.dart';
import 'package:gloou/widgets/button_widget.dart';
import 'package:http/http.dart' as http;

class Interest extends StatefulWidget {
  const Interest({Key? key}) : super(key: key);

  @override
  _InterestState createState() => _InterestState();
}

class _InterestState extends State<Interest> {
  bool selectedChoice = false;

  final TokenLogic tokenLogic = TokenLogic();
  InterestModel _interestModel = InterestModel(data: []);

  bool isCircular = true;
  late List interestData = [];

  fetchInterest() async {
    var token = await tokenLogic.getToken();
    if (token != null) {
      var url = Uri.parse(ApiUtils.API_URL + '/User/GetInterests');
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
    // TODO: implement initState
    super.initState();
    _interestModel.data = <AddinterestModel>[];
    fetchInterest().then((data) {
      setState(() {
        if (data != null) {
          var interestInfo = data['data'];
          if (interestInfo.length > 0) {
            interestData = interestInfo;
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Interests',
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
      body: isCircular
          ? Center(
              child: CircularProgressIndicator(),
            )
          : interestData.length > 0
              ? Column(
                  children: [
                    Expanded(
                        child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(15),
                      children: List.generate(interestData.length, (i) {
                        var addInterestInfo = interestData[i]['interests']
                            .where((info) => info['isSelected'] == true)
                            .toList();
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                interestData[i]['category'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Container(
                                height: 200,
                                child: GridView.count(
                                  crossAxisCount: 2,
                                  scrollDirection: Axis.horizontal,
                                  mainAxisSpacing: 10,
                                  physics: const ClampingScrollPhysics(),
                                  children: List.generate(
                                      interestData[i]['interests'].length, (j) {
                                    print('true details: $addInterestInfo');
                                    return Container(
                                      child: ChoiceChip(
                                        label: Text(interestData[i]['interests']
                                            [j]['name']),
                                        labelStyle: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: interestData[i]['interests'][j]
                                                  ['isSelected']
                                              ? Colors.white
                                              : Color(0xFF213053),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 5),
                                        selectedColor:
                                            Theme.of(context).primaryColor,
                                        backgroundColor: Color(0xFFE3E4F7),
                                        selected: interestData[i]['interests']
                                            [j]['isSelected'],
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        onSelected: (selected) {
                                          setState(() {
                                            interestData[i]['interests'][j]
                                                ['isSelected'] = selected;
                                            selected
                                                ? _interestModel.data.add(
                                                    AddinterestModel(
                                                      category: interestData[i]
                                                              ['interests'][j]
                                                          ['category'],
                                                      interestID:
                                                          interestData[i]
                                                                  ['interests']
                                                              [j]['id'],
                                                      name: interestData[i]
                                                              ['interests'][j]
                                                          ['name'],
                                                    ),
                                                  )
                                                : _interestModel.data
                                                    .removeWhere(
                                                        (interestFetch) {
                                                    print(interestFetch
                                                        .interestID);
                                                    return interestFetch
                                                            .interestID ==
                                                        interestData[i]
                                                                ['interests'][j]
                                                            ['id'];
                                                  });
                                            print(_interestModel.data);
                                          });
                                        },
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    )),
                    ButtonWidget(
                      title: 'Save',
                      onClick: onSubmit,
                      isButtonActive: false,
                      buttonColor: Theme.of(context).primaryColor,
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                )
              : Center(
                  child: Text('No Interest at the moment'),
                ),
    );
  }

  void onSubmit() async {
    var token = await tokenLogic.getToken();
    if (token != null) {
      print(jsonEncode(_interestModel.data.toList()));
      var url = Uri.parse(ApiUtils.API_URL + '/User/CreateInterests');
      var httpClient = http.Client();
      var response = await httpClient.post(
        url,
        body: jsonEncode(_interestModel.data.toList()),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        },
      );
      if (response.statusCode == 200) {
        Navigator.of(context).pop();
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
}
