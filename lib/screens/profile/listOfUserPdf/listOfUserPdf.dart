import 'package:flutter/material.dart';
import 'package:gloou/widgets/card_widget.dart';

class ListOfUserPdf extends StatefulWidget {
  final List postData;
  final String token;
  const ListOfUserPdf({
    Key? key,
    required this.postData,
    required this.token,
  }) : super(key: key);

  @override
  _ListOfUserPdfState createState() => _ListOfUserPdfState();
}

class _ListOfUserPdfState extends State<ListOfUserPdf> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (BuildContext context, int i) {
        return widget.postData[i]['isText']
            ? SizedBox.shrink()
            : widget.postData[i]['files'][0]['fileType'] == 'application/pdf'
                ? CardWidget(
                    mediaName: widget.postData[i]['files'][0]['fileName'],
                    token: widget.token,
                    mediaType: widget.postData[i]['files'][0]['fileType'],
                  )
                : Text('data');
      },
      itemCount: widget.postData[0].length,
    );
  }
}
