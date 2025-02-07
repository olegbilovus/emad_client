import 'dart:typed_data';
import 'dart:html' as html;

class SavePDFHelper {
  static Future<void> savePDF(Uint8List pdfData, String fileName) async {
    final blob = html.Blob([pdfData]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute('download', fileName)
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}
