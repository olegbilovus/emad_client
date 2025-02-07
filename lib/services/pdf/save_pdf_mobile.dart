import 'dart:developer' as dev;
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SavePDFHelper {
  static Future<void> savePDF(Uint8List pdfData, String fileName) async {
    if (await requestStoragePermission()) {
      final path = await getDownloadsDirectory();
      final file = File('${path?.path}/$fileName');
      await file.writeAsBytes(pdfData);
    } else {
      dev.log('Permission denied');
    }
  }

  static Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      return status.isGranted;
    }
    return true;
  }
}
