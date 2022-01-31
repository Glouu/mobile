import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:gloou/shared/api_environment/api_utils.dart';
import 'package:gloou/shared/utilities/convert_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

class CardWidget extends StatefulWidget {
  final String mediaName;
  final String token;
  final String mediaType;
  const CardWidget({
    Key? key,
    required this.mediaName,
    required this.token,
    required this.mediaType,
  }) : super(key: key);

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  final ConvertImage convertImage = ConvertImage();
  late VideoPlayerController _videoPlayerController;
  late final File pdfFile;
  bool isFileLoading = true;

  void videoSettings() {
    _videoPlayerController = VideoPlayerController.network(
      ApiUtils.API_URL + '/Post/GetFile/${widget.mediaName}',
      httpHeaders: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ${widget.token}'
      },
    )
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((_) {
        setState(() {
          _videoPlayerController.pause();
        });
      });
  }

  Future<File> fetchFile() async {
    var fileUrl =
        Uri.parse(ApiUtils.API_URL + '/Post/GetFile/${widget.mediaName}');
    var response = await http.get(
      fileUrl,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ${widget.token}'
      },
    );
    var bytes = response.bodyBytes;
    return storeDFile(bytes);
  }

  Future<File> storeDFile(List<int> bytes) async {
    var dir = await getApplicationDocumentsDirectory();

    var file = File('${dir.path}/${widget.mediaName}');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.mediaType == 'video/mp4'
        ? videoSettings()
        : widget.mediaType == 'application/pdf'
            ? fetchFile().then((data) {
                setState(() {
                  pdfFile = data;
                  isFileLoading = false;
                });
              })
            : null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.mediaType.isNotEmpty
        ? Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: widget.mediaType == 'image/jpeg'
                    ? Image.network(
                        ApiUtils.API_URL + '/Post/GetFile/${widget.mediaName}',
                        headers: {
                          HttpHeaders.contentTypeHeader: 'application/json',
                          HttpHeaders.authorizationHeader:
                              'Bearer ${widget.token}'
                        },
                        fit: BoxFit.cover,
                      )
                    : widget.mediaType == 'video/mp4'
                        ? AspectRatio(
                            aspectRatio: 2 / 1,
                            child: _videoPlayerController.value.isInitialized
                                ? VideoPlayer(_videoPlayerController)
                                : Center(
                                    child: CircularProgressIndicator(),
                                  ),
                          )
                        : widget.mediaType == 'application/pdf'
                            ? isFileLoading
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : PDFView(
                                    filePath: pdfFile.path,
                                  )
                            : Container(),
              ),
              Positioned(
                  top: 0,
                  child: Icon(
                    widget.mediaType == 'image/jpeg'
                        ? Icons.image_outlined
                        : widget.mediaType == 'video/mp4'
                            ? Icons.play_circle
                            : Icons.file_present_rounded,
                    color: Colors.white,
                  ))
            ],
          )
        : Container();
  }
}
