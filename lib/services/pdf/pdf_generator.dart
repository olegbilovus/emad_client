import 'dart:developer' as dev;
import 'dart:typed_data';

import 'package:emad_client/model/image_data.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

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
    this.fileName = "PECS-${sentence.replaceAll(" ", "_").toLowerCase()}.pdf";
  }

  Future<Uint8List> generatePDF() async {
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

    final Uint8List bytes = await pdf.save();
    return bytes;
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
}
