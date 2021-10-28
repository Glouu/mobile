import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gloou/widgets/text_widget.dart';

class Message extends StatefulWidget {
  const Message({Key? key}) : super(key: key);

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Bounce(
              child: SvgPicture.asset('assets/images/new_chat_icon.svg'),
              duration: Duration(milliseconds: 500),
              onPressed: () {},
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 15.0,
          right: 15.0,
        ),
        child: ListView(
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

          ],
        ),
      ),
    );
  }
}
