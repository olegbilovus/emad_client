import 'dart:developer' as dev;

import 'package:http/http.dart' as http;

class ApiService {
  //url del backend
  //static String url = "https://api.3111616.xyz";

  static String url =
      "https://7325af20a14a05d54ccbd2c6111844da.3111616.xyz"; //dev url
  final _clientApiKey = "84a5bfe58847ed1709f3cd075db8651f";
  static final _logName = "API";

  ApiService();

  static setUrl(String url) {
    ApiService.url = url;
  }

  //metodo che chiama il servizio di generazione delle immagini di Arasaac
  Future<http.Response> getImages(bool sex, bool violence, String prompt,
      String lan, bool textCorrection) async {
    String path =
        "/v1/images/?sex=$sex&violence=$violence&text=$prompt&language=$lan&fix_sentence=$textCorrection";
    var uri = Uri.parse(url + path);
    dev.log("getImages: ${uri.toString()}", name: _logName);
    return http.get(uri);
  }

  //metodo che chiama il servizio di GenAI di Azure
  Future<http.Response> getGenAImage(String prompt) {
    String path = "/v1/genai/dalle3/images/?text=$prompt";
    var uri = Uri.parse(url + path);
    dev.log("getGenAIImage: ${uri.toString()}", name: _logName);
    return http.get(uri,
        headers: {"accept": "application/json", "api-key": _clientApiKey});
  }

  //metodo che chiama il servizio di generazione delle immagini per una keyword
  Future<http.Response> getImagesFromKeyword(
      bool sex, bool violence, String keyword, String lan) {
    String path =
        "/v2/images/?sex=$sex&violence=$violence&text=$keyword&language=$lan&one_image=false";
    var uri = Uri.parse(url + path);
    dev.log("getImagesFromKeyword: ${uri.toString()}", name: _logName);
    return http.get(uri);
  }
}
