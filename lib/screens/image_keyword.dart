import 'dart:convert';
import 'dart:developer' as dev;

import 'package:emad_client/model/image_data.dart';
import 'package:emad_client/services/cloud/firebase_cloud_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ImageKeyword extends StatelessWidget {
  final ImageData imageData;
  final FirebaseCloudStorage imagesService;

  const ImageKeyword(
      {super.key, required this.imageData, required this.imagesService});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Image>(
        future: _setCorrectImage(imageData),
        builder: (BuildContext context, AsyncSnapshot<Image> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return snapshot.data!;
          }
        });
  }

  Future<Image> _setCorrectImage(ImageData imageData) async {
    if (FirebaseAuth.instance.currentUser != null) {
      try {
        final image = await imagesService.getImageByKeyword(
            userId: FirebaseAuth.instance.currentUser!.uid,
            keyword: imageData.keyword);

        return Image.memory(
          base64Decode(image.base64),
          width: 200,
          height: 220,
          fit: BoxFit.contain,
        );
      } catch (_) {
        dev.log(
            "User did not uploaded an image for the keyword: ${imageData.keyword}");
      }
    }

    return Image.network(
      imageData.url,
      width: 200,
      height: 220,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 150,
          height: 150,
          color: Colors.grey,
          child: const Icon(Icons.broken_image),
        );
      },
    );
  }
}
