import 'package:gloou/shared/api_environment/api_utils.dart';
import 'package:gloou/shared/secure_storage/secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';

class TokenLogic {
  final SecureStorage secureStorage = SecureStorage();

  getToken() async {
    var token = await secureStorage.readSecureData('token');
    return token;
  }

  tokenPayload(String token) async {
    Map<String, dynamic> payload = Jwt.parseJwt(token);
    return payload;
  }

  isTokenValid() async {
    var token = await getToken();
    if (token != null) {
      var payload = await tokenPayload(token);
      var payloadIss = payload['iss'];
      if (payloadIss == ApiUtils.URL) {
        return true;
      }
      return false;
    }
    return false;
  }

  getId() async {
    var token = await getToken();
    if (token != null) {
      var payload = await tokenPayload(token);
      var payloadId = payload['id'];
      return payloadId;
    }
  }

  getEmail() async {
    var token = await getToken();
    if (token != null) {
      var payload = await tokenPayload(token);
      var payloadEmail = payload['email'];
      return payloadEmail;
    }
  }
}
