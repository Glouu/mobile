class ApiUtils {
  // Endpoint
  static const String URL = "https://glouu.com";
  static const String API_URL = "http://192.81.212.184/api";
}

class Header {
  static const Map<String, String> noBearerHeader = {
    "Accept": "application/json",
    "Content-Type": "application/json",
    "Access-Control-Allow-Headers":
        "Origin, X-Requested-With, Content-Type, Accept",
  };
}
