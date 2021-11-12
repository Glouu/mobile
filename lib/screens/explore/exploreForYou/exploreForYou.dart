import 'package:flutter/material.dart';
import 'package:gloou/widgets/card_widget.dart';
import 'package:gloou/widgets/text_widget.dart';

class ExploreForYou extends StatefulWidget {
  const ExploreForYou({Key? key}) : super(key: key);

  @override
  _ExploreForYouState createState() => _ExploreForYouState();
}

class _ExploreForYouState extends State<ExploreForYou> {
  TextEditingController searchController = TextEditingController();

  final FocusNode searchNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            textInput: searchController,
            textNode: searchNode,
            labelTitle: 'Search',
            validationMsg: (value) {},
          ),
          SizedBox(
            height: 30,
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#bussit',
                    style: TextStyle(),
                  ),
                  Container(
                    // height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 5,
                          color: Colors.red.shade50,
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '34k',
                          style: TextStyle(color: Colors.red),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 10,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, i) {
                  return CardWidget(
                    mediaName: '',
                    token: '',
                    mediaType: '',
                  );
                }, // CardWidget(index: i),
                itemCount: 3,
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#bussit',
                    style: TextStyle(),
                  ),
                  Container(
                    // height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 5,
                          color: Colors.red.shade50,
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '34k',
                          style: TextStyle(color: Colors.red),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 10,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, i) {
                  return CardWidget(
                    mediaName: '',
                    token: '',
                    mediaType: '',
                  );
                }, // CardWidget(index: i),
                itemCount: 3,
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#bussit',
                    style: TextStyle(),
                  ),
                  Container(
                    // height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 5,
                          color: Colors.red.shade50,
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '34k',
                          style: TextStyle(color: Colors.red),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 10,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, i) {
                  return CardWidget(
                    mediaName: '',
                    token: '',
                    mediaType: '',
                  );
                }, // CardWidget(index: i),
                itemCount: 3,
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#bussit',
                    style: TextStyle(),
                  ),
                  Container(
                    // height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 5,
                          color: Colors.red.shade50,
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '34k',
                          style: TextStyle(color: Colors.red),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 10,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, i) {
                  return CardWidget(
                    mediaName: '',
                    token: '',
                    mediaType: '',
                  );
                }, // CardWidget(index: i),
                itemCount: 3,
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#bussit',
                    style: TextStyle(),
                  ),
                  Container(
                    // height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 5,
                          color: Colors.red.shade50,
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '34k',
                          style: TextStyle(color: Colors.red),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 10,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, i) {
                  return CardWidget(
                    mediaName: '',
                    token: '',
                    mediaType: '',
                  );
                }, // CardWidget(index: i),
                itemCount: 3,
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#bussit',
                    style: TextStyle(),
                  ),
                  Container(
                    // height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 5,
                          color: Colors.red.shade50,
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '34k',
                          style: TextStyle(color: Colors.red),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 10,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, i) {
                  return CardWidget(
                    mediaName: '',
                    token: '',
                    mediaType: '',
                  );
                }, // CardWidget(index: i),
                itemCount: 3,
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#bussit',
                    style: TextStyle(),
                  ),
                  Container(
                    // height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 5,
                          color: Colors.red.shade50,
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '34k',
                          style: TextStyle(color: Colors.red),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 10,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, i) {
                  return CardWidget(
                    mediaName: '',
                    token: '',
                    mediaType: '',
                  );
                }, // CardWidget(index: i),
                itemCount: 3,
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#bussit',
                    style: TextStyle(),
                  ),
                  Container(
                    // height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 5,
                          color: Colors.red.shade50,
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '34k',
                          style: TextStyle(color: Colors.red),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 10,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, i) {
                  return CardWidget(
                    mediaName: '',
                    token: '',
                    mediaType: '',
                  );
                }, // CardWidget(index: i),
                itemCount: 3,
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#bussit',
                    style: TextStyle(),
                  ),
                  Container(
                    // height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 5,
                          color: Colors.red.shade50,
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '34k',
                          style: TextStyle(color: Colors.red),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 10,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, i) {
                  return CardWidget(
                    mediaName: '',
                    token: '',
                    mediaType: '',
                  );
                }, // CardWidget(index: i),
                itemCount: 3,
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#bussit',
                    style: TextStyle(),
                  ),
                  Container(
                    // height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 5,
                          color: Colors.red.shade50,
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '34k',
                          style: TextStyle(color: Colors.red),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 10,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, i) {
                  return CardWidget(
                    mediaName: '',
                    token: '',
                    mediaType: '',
                  );
                }, // CardWidget(index: i),
                itemCount: 3,
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
