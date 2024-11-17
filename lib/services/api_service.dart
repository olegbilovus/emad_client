import 'package:http/http.dart' as http;

class ApiService {
  //url del backend
  final String url = "https://7325af20a14a05d54ccbd2c6111844da.3111616.xyz";

  ApiService();

  //metodo che chiama il servizio di generazione delle immagini di Arasaac
  Future<http.Response> getImages(
      bool sex, bool violence, String prompt, String lan) async {
    String images =
        "/v1/images/?sex=$sex&violence=$violence&text=$prompt&language=$lan";
    print("L'url della richiesta GET è: ${url + images}");
    return http.get(Uri.parse(url + images));
  }

  //metodo che chiama il servizio di GenAI di Azure
}
