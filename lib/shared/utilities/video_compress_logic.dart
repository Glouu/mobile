import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:video_compress/video_compress.dart';

class VideoCompressLogic {
  static Future<MediaInfo?> compressVideo(
    File file,
    BuildContext context,
  ) async {
    try {
      await VideoCompress.setLogLevel(0);
      final size = await file.length();
      final videoSize = size / 1000000;
      print('original file size: $videoSize');
      if (videoSize > 39) {
        return VideoCompress.compressVideo(
          file.path,
          quality: VideoQuality.MediumQuality,
          includeAudio: true,
        );
      } else {
        return VideoCompress.compressVideo(
          file.path,
          quality: VideoQuality.HighestQuality,
          includeAudio: true,
        );
      }
    } catch (e) {
      VideoCompress.cancelCompression();
      Navigator.of(context).pop();
    }
  }
}
