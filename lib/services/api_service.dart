import 'package:http/http.dart' as http;
import 'dart:developer' as dev;

class ApiService {
  //url del backend
  //final String url = "https://api.3111616.xyz";
  final String url =
      "https://7325af20a14a05d54ccbd2c6111844da.3111616.xyz"; //testing url
  final _clientApiKey = "84a5bfe58847ed1709f3cd075db8651f";

  ApiService();

  //metodo che chiama il servizio di generazione delle immagini di Arasaac
  Future<http.Response> getImages(
      bool sex, bool violence, String prompt, String lan) async {
    String path =
        "/v1/images/?sex=$sex&violence=$violence&text=$prompt&language=$lan";
    dev.log("L'url della richiesta GET è: ${url + path}");
    return http.get(Uri.parse(url + path));
  }

  //metodo che chiama il servizio di GenAI di Azure
  Future<http.Response> getGenAImage(String prompt) {
    String path = "/v1/genai/dalle3/images/?text=$prompt";
    dev.log("L'url della richiesta GET è: ${url + path}");
    return http.get(Uri.parse(url + path),
        headers: {"accept": "application/json", "api-key": _clientApiKey});
  }

  //metodo che chiama il servizio di generazione delle immagini per una keyword
  Future<http.Response> getImagesFromKeyword(
      bool sex, bool violence, String keyword, String lan) {
    String path =
        "/v2/images/?sex=$sex&violence=$violence&text=$keyword&language=$lan&one_image=false";
    dev.log("L'url della richiesta GET è: ${url + path}");
    return http.get(Uri.parse(url + path));
  }
}
