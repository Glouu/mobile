import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';

class ConvertImage {
  base64ToImage(String image) async {
    var splitData = image.split(",")[1];
    Uint8List decodeBase64 = base64Decode(splitData);
    return decodeBase64;
  }

  imageToBase64(Uint8List data) async {
    var dataToBase64 = base64Encode(data);
    var saveData = 'data:image/jpeg;base64,$dataToBase64';
    return saveData;
  }
}
