import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gloou/shared/api_environment/api_utils.dart';
import 'package:video_player/video_player.dart';

class FeedVideoWidget extends StatefulWidget {
  final String fileName;
  final String token;
  const FeedVideoWidget({
    Key? key,
    required this.fileName,
    required this.token,
  }) : super(key: key);

  @override
  State<FeedVideoWidget> createState() => _FeedVideoWidgetState();
}

class _FeedVideoWidgetState extends State<FeedVideoWidget> {
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _videoPlayerController = VideoPlayerController.network(
      ApiUtils.API_URL + '/Post/GetFile/${widget.fileName}',
      httpHeaders: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ${widget.token}'
      },
    )
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((_) {
        setState(() {
          _videoPlayerController.play();
        });
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // print(
    //     'this is video aspect ratio: ${_videoPlayerController.value.aspectRatio}');
    return Container(
      height: (size.height) / 1.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: AspectRatio(
          aspectRatio: 2 / 1,
          child: _videoPlayerController.value.isInitialized
              ? VideoPlayer(_videoPlayerController)
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
}
