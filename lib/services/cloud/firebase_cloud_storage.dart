import 'dart:developer' as dev;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emad_client/services/cloud/cloud_storage_constants.dart';
import 'package:emad_client/services/cloud/cloud_storage_exception.dart';
import 'package:emad_client/services/cloud/dto.dart';

class FirebaseCloudStorage {
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();

  FirebaseCloudStorage._sharedInstance();

  factory FirebaseCloudStorage() => _shared;

  final images = FirebaseFirestore.instance.collection(imagesCollection);

  Stream<Iterable<CloudImage>> allImages({required String userId}) =>
      images.where(userIdField, isEqualTo: userId).snapshots().map((snapshot) =>
          snapshot.docs.map((doc) => CloudImage.fromSnapshot(doc)));

  Future<CloudImage> addImage(
      {required String userId,
      required String keyword,
      required String base64}) async {
    try {
      final prevImage =
          await getImageByKeyword(userId: userId, keyword: keyword);
      await deleteImage(imageId: prevImage.imageId);
      dev.log("Deleted already existing image for keyword: $keyword");
    } catch (_) {}

    final doc = await images
        .add({userIdField: userId, keywordField: keyword, base64Field: base64});
    final fetchedImage = await doc.get();
    dev.log("Added image for keyword: $keyword");

    return CloudImage(
      imageId: fetchedImage.id,
      keyword: keyword,
      base64: base64,
      userId: userId,
    );
  }

  Future<CloudImage> getImageByKeyword(
      {required String userId, required String keyword}) async {
    final fetchedImages = images
        .where(userIdField, isEqualTo: userId)
        .where(keywordField, isEqualTo: keyword)
        .snapshots();
    if (await fetchedImages.isEmpty) {
      throw CouldNotFindImageException();
    }

    final imageDocs = (await fetchedImages.first)
        .docs
        .map((doc) => CloudImage.fromSnapshot(doc));

    return imageDocs.first;
  }

  Future<void> deleteImage({required String imageId}) async {
    try {
      await images.doc(imageId).delete();
    } catch (_) {
      throw const CloudStorageException();
    }
  }
}
