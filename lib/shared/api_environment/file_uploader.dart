import 'dart:async';
import 'dart:io';

import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:gloou/shared/secure_storage/secure_storage.dart';
import 'package:gloou/shared/token/token.dart';

class BackgroundUploader {
  BackgroundUploader._();

  final TokenLogic tokenLogic = TokenLogic();
  final SecureStorage secureStorage = SecureStorage();
  static final FlutterUploader flutterUploader = FlutterUploader();

  uploadFile(String url, File file) async {
    var token = await tokenLogic.getToken();
    final taskId = await flutterUploader.enqueue(
      MultipartFormDataUpload(
        url: url,
        method: UploadMethod.PUT,
        headers: {
          HttpHeaders.contentTypeHeader: 'multipart/form-data',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        },
        files: [
          FileItem(
            path: file.path,
            field: 'file',
          )
        ],
        tag: 'Video Uploading',
      ),
    );

    return taskId;
  }
}
