import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:emad_client/model/image_data.dart';
import 'dart:html' as web;
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'dart:developer' as dev;

class PdfGenerator {
  late List<ImageData> generatedImages;
  late String sentence;
  late String fileName;
  late pw.Document pdf; // Viene creata un'istanza dinamica di `pw.Document`

  PdfGenerator() {
    _initializePdf(); // Inizializza l'istanza di PDF all'avvio
  }

  void _initializePdf() {
    pdf = pw.Document();
  }

  void setGeneratedImages(List<ImageData> generatedImages) {
    this.generatedImages = generatedImages;
  }

  void setSentence(String sentence) {
    this.sentence = sentence;
  }

  void setFilename() {
    this.fileName = "${sentence}_PECS.pdf";
  }

  Future<void> generatePDF() async {
    _initializePdf(); // Crea un nuovo documento PDF ogni volta

    // Carica tutte le immagini prima di costruire il PDF
    final List<pw.Widget> imageWidgets = await Future.wait(
      generatedImages.map((imageData) async {
        final pw.Widget imageWidget = await _buildImage(imageData.url);
        return pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text(
              imageData.keyword,
              style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            imageWidget,
            pw.SizedBox(height: 20),
          ],
        );
      }),
    );

    if (imageWidgets.isNotEmpty) {
      // Aggiungi una pagina per ogni immagine
      for (var widget in imageWidgets) {
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              return pw.Center(
                // Centra il contenuto sulla pagina
                child: widget,
              );
            },
          ),
        );
      }
    } else {
      dev.log("Errore: nessuna immagine da aggiungere al PDF.");
    }

    // Salva il documento PDF
    final Uint8List bytes = await pdf.save();

    if (kIsWeb) {
      final blob = web.Blob([bytes], 'application/pdf');
      final url = web.Url.createObjectUrlFromBlob(blob);
      // ignore: unused_local_variable
      final anchor = web.AnchorElement(href: url)
        ..setAttribute("download", fileName)
        ..click();
      web.Url.revokeObjectUrl(url);
    } else {
      await _savePdfToDownloads(bytes);
    }
  }

  // Metodo per scaricare un'immagine da URL e convertirla in PDF
  Future<pw.Widget> _buildImage(String imageUrl) async {
    try {
      dev.log("Caricamento immagine da URL: $imageUrl");
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final Uint8List imageData = response.bodyBytes;
        final pdfImage = pw.MemoryImage(imageData);
        dev.log("Immagine caricata con successo: $imageUrl");

        return pw.Image(pdfImage, width: 250, height: 250);
      } else {
        dev.log("Errore nel caricamento dell'immagine: ${response.statusCode}");
        return pw.Text("Impossibile caricare l'immagine.");
      }
    } catch (e) {
      dev.log("Errore nell'ottenere l'immagine: $e");
      return pw.Text("Errore nell'ottenere l'immagine.");
    }
  }

  Future<void> _savePdfToDownloads(Uint8List bytes) async {
    if (await _requestStoragePermission()) {
      Directory? downloadsDir;

      if (Platform.isAndroid) {
        downloadsDir = Directory('/storage/emulated/0/Download');
      } else if (Platform.isIOS) {
        downloadsDir = await getApplicationDocumentsDirectory();
      }

      if (downloadsDir != null) {
        final filePath = '${downloadsDir.path}/$fileName';
        final File file = File(filePath);
        await file.writeAsBytes(bytes);
        dev.log("PDF salvato in: $filePath");
      } else {
        dev.log("Errore: impossibile trovare la cartella Download.");
      }
    } else {
      dev.log("Permessi di scrittura negati.");
    }
  }

  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      return status.isGranted;
    }
    return true;
  }
}
