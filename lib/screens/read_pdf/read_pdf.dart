import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class ReadPdf extends StatefulWidget {
  final String filePath;
  final String fileName;
  const ReadPdf({
    Key? key,
    required this.filePath,
    required this.fileName,
  }) : super(key: key);

  @override
  _ReadPdfState createState() => _ReadPdfState();
}

class _ReadPdfState extends State<ReadPdf> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          widget.fileName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.close),
        ),
        actions: [
          Align(
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 6,
                      color: Colors.orange,
                    )
                  ]),
              child: Text(
                'PDF',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        primary: false,
        padding: EdgeInsets.only(left: 15, right: 15),
        children: [
          SingleChildScrollView(
            child: Container(
              height: (size.height) / 1,
              width: size.width,
              child: PDFView(
                enableSwipe: true,
                swipeHorizontal: true,
                autoSpacing: false,
                pageFling: false,
                filePath: widget.filePath,
              ),
            ),
          )
        ],
      ),
    );
  }
}
