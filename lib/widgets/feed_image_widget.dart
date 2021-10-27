import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:gloou/shared/api_environment/api_utils.dart';

class FeedImageWidget extends StatelessWidget {
  final String fileName;
  final String token;
  const FeedImageWidget({
    Key? key,
    required this.fileName,
    required this.token,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: (size.height) / 1.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: NetworkImage(
            ApiUtils.API_URL + '/Post/GetFile/$fileName',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.authorizationHeader: 'Bearer $token'
            },
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
