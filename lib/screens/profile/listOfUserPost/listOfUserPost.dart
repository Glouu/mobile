import 'package:flutter/material.dart';
import 'package:gloou/widgets/card_widget.dart';

class ListOfUserPost extends StatefulWidget {
  final List postData;
  final String token;
  const ListOfUserPost({
    Key? key,
    required this.postData,
    required this.token,
  }) : super(key: key);

  @override
  _ListOfUserPostState createState() => _ListOfUserPostState();
}

class _ListOfUserPostState extends State<ListOfUserPost> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (BuildContext context, int i) {
        return widget.postData[i]['isText']
            ? ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: Center(child: Text(widget.postData[i]['caption'])),
              )
            : CardWidget(
                mediaName: widget.postData[i]['files'][0]['fileName'],
                token: widget.token,
                mediaType: widget.postData[i]['files'][0]['fileType'],
              );
      },
      itemCount: widget.postData.length,
    );
  }
}
