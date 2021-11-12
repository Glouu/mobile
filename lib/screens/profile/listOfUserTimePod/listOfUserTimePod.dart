import 'package:flutter/material.dart';
import 'package:gloou/widgets/card_widget.dart';

class ListOfUserTimePod extends StatefulWidget {
  final List postData;
  final String token;
  const ListOfUserTimePod({
    Key? key,
    required this.postData,
    required this.token,
  }) : super(key: key);

  @override
  _ListOfUserTimePodState createState() => _ListOfUserTimePodState();
}

class _ListOfUserTimePodState extends State<ListOfUserTimePod> {
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
