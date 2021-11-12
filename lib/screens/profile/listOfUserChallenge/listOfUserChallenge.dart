import 'package:flutter/material.dart';
import 'package:gloou/widgets/card_widget.dart';

class ListOfUserChallenge extends StatefulWidget {
  final List postData;
  final String token;
  const ListOfUserChallenge({
    Key? key,
    required this.postData,
    required this.token,
  }) : super(key: key);

  @override
  _ListOfUserChallengeState createState() => _ListOfUserChallengeState();
}

class _ListOfUserChallengeState extends State<ListOfUserChallenge> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (BuildContext context, int i) {
        return CardWidget(
            mediaName: widget.postData[i]['files'][0]['fileName'],
            token: widget.token,
            mediaType: widget.postData[i]['files'][0]['fileType']);
      },
      itemCount: widget.postData.length,
    );
  }
}
