import 'dart:convert';
import 'dart:developer' as dev;

import 'package:emad_client/costants/ai_styles.dart';
import 'package:emad_client/model/image_data.dart';
import 'package:emad_client/services/api_service.dart';
import 'package:flutter/material.dart';

class ImageGeneratorController {
  final ApiService _apiService = ApiService();

  Future<(List<ImageData>, String?)> generateImagesFromPrompt(
      {required String url,
      required bool violence,
      required bool sex,
      required String prompt,
      required String language,
      required bool textCorrection}) async {
    final response = await _apiService.getImages(
        sex, violence, prompt, language, textCorrection);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final String urlRoot = data['url_root'];
      final List images = data['images'];

      String? fixedTest = data['fixed_text'].toString();
      if (fixedTest == "null") {
        fixedTest = null;
      }
      var imagesList = images.map<ImageData>((image) {
        return ImageData(
          url: "$urlRoot${image['id']}.png", // URL completo dell'immagine
          keyword: image['keyword'], // Keyword associata all'immagine
        );
      }).toList();

      // Creiamo una lista di oggetti ImageData
      return (imagesList, fixedTest);
    } else {
      throw Exception("Errore nella risposta API: ${response.statusCode}");
    }
  }

  Future<ImageData> generateUsingIA(String prompt, String keyword) async {
    try {
      dev.log("Prompt: $prompt");
      final response = await _apiService.getGenAImage(prompt);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['url'] == null || data['url'].isEmpty) {
          throw Exception("URL immagine mancante nella risposta.");
        }

        final url = data['url'];
        dev.log("Url immagine genAI: $url");
        return ImageData(
          url: url,
          keyword: keyword,
        );
      } else {
        throw Exception(
            "Errore API: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      dev.log("Errore durante la generazione immagine: $e");
      rethrow; // Propaga l'errore per gestirlo a monte
    }
  }

  String concatenaPrompt(
      BuildContext context, int stile, TextEditingController promptController) {
    switch (stile) {
      case 1:
        return "Disegna ${promptController.text} nello stile ${Stili.pittogrammi.name}";
      case 2:
        return "Disegna ${promptController.text} nello stile ${Stili.realismo.name}";
      case 3:
        return "Disegna ${promptController.text} nello stile ${Stili.cartoon.name}";
      default:
        return "Disegna ${promptController.text}";
    }
  }

  Future<List<String>> generateImagesFromKeyword({
    required bool violence,
    required bool sex,
    required String keyword,
    required String language,
  }) async {
    final response = await _apiService.getImagesFromKeyword(
        sex, violence, keyword, language);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final String urlRoot = data['url_root'];
      final List images = data['keyword_images'][0]['images'];

      //crea una lista di URL
      final List<String> imageUrls = images.map<String>((image) {
        final int id = image['id'];
        return "$urlRoot$id.png";
      }).toList();

      return imageUrls;
    } else {
      throw Exception("Errore nella risposta API: ${response.statusCode}");
    }
  }
}
