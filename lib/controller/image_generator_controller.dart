import 'dart:convert';
import 'package:emad_client/services/api_service.dart';

class ImageGeneratorController {
  final ApiService _apiService = ApiService();

  Future<List<String>> generateImagesFromPrompt(
      {required bool violence,
      required bool sex,
      required String prompt,
      required String language}) async {
    final response =
        await _apiService.getImages(false, false, prompt, language);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final String urlRoot = data['url_root'];
      final List images = data['images'];
      return images
          .map<String>((image) => "$urlRoot${image['id']}.png")
          .toList();
    } else {
      throw Exception("Errore nella risposta API: ${response.statusCode}");
    }
  }
}
