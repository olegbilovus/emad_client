import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emad_client/services/cloud/cloud_storage_constants.dart';
import 'package:flutter/foundation.dart';

@immutable
class CloudImage {
  final String imageId;
  final String keyword;
  final String base64;
  final String userId;

  const CloudImage({
    required this.imageId,
    required this.keyword,
    required this.base64,
    required this.userId,
  });

  CloudImage.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : imageId = snapshot.id,
        keyword = snapshot.data()[keywordField] as String,
        base64 = snapshot.data()[base64Field] as String,
        userId = snapshot.data()[userIdField] as String;
}
