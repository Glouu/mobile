import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final _storage = FlutterSecureStorage();

  writeSecureData(String key, String value) async {
    var writeData = await _storage.write(key: key, value: value);
    return writeData;
  }

  readSecureData(String key) async {
    var readData = await _storage.read(key: key);
    return readData;
  }

  readAllSecureData() async {
    var readAllData = await _storage.readAll();
    return readAllData;
  }

  deleteSecureData(String key) async {
    var deleteData = await _storage.delete(key: key);
    return deleteData;
  }

  deleteAllSecureData() async {
    var deleteAllData = await _storage.deleteAll();
    return deleteAllData;
  }
}
