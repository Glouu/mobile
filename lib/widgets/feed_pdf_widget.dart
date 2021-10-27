import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:gloou/screens/read_pdf/read_pdf.dart';
import 'package:gloou/shared/api_environment/api_utils.dart';
import 'package:gloou/shared/colors/colors.dart';
import 'package:gloou/shared/token/token.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class FeedPdfWidget extends StatefulWidget {
  final String fileName;
  final String mainFileName;
  const FeedPdfWidget({
    Key? key,
    required this.fileName,
    required this.mainFileName,
  }) : super(key: key);

  @override
  State<FeedPdfWidget> createState() => _FeedPdfWidgetState();
}

class _FeedPdfWidgetState extends State<FeedPdfWidget> {
  late final File pdfFile;
  bool isLoading = true;

  final TokenLogic tokenLogic = TokenLogic();

  Future<File> fetchFile() async {
    var token = await tokenLogic.getToken();
    var fileUrl =
        Uri.parse(ApiUtils.API_URL + '/Post/GetFile/${widget.fileName}');
    var response = await http.get(
      fileUrl,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );
    var bytes = response.bodyBytes;
    return storeDFile(bytes);
  }

  Future<File> storeDFile(List<int> bytes) async {
    var dir = await getApplicationDocumentsDirectory();

    var file = File('${dir.path}/${widget.fileName}');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchFile().then((data) {
      setState(() {
        pdfFile = data;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.2,
      color: textFeedColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: GestureDetector(
        onTap: () async {
          if (!isLoading) {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ReadPdf(
                  filePath: pdfFile.path,
                  fileName: widget.fileName,
                ),
              ),
            );
          }
        },
        child: Row(
          children: [
            Container(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFDAE9FF),
                  border: Border.all(
                    color: Color(0xFFDAE9FF),
                    width: 20,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: Container(
                  height: 40,
                  width: 40,
                  child: isLoading
                      ? CircularProgressIndicator()
                      : GestureDetector(
                          onTap: () {
                            if (!isLoading) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ReadPdf(
                                    filePath: pdfFile.path,
                                    fileName: widget.fileName,
                                  ),
                                ),
                              );
                            }
                          },
                          child: PDFView(
                            filePath: pdfFile.path,
                          ),
                        ),
                ),
                // Icon(
                //   Icons.folder,
                //   color: Color(0xFF7CB0FF),
                //   size: 40,
                // ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.fileName,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('pagesDetails')
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
