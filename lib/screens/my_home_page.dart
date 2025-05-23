import 'dart:convert';
import 'dart:developer' as dev;

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:emad_client/controller/history_controller.dart';
import 'package:emad_client/controller/image_generator_controller.dart';
import 'package:emad_client/controller/network_controller.dart';
import 'package:emad_client/extensions/buildcontext/loc.dart';
import 'package:emad_client/model/image_data.dart';
import 'package:emad_client/screens/image_keyword.dart';
import 'package:emad_client/services/api_service.dart';
import 'package:emad_client/services/enum.dart';
import 'package:emad_client/services/pdf/pdf_generator.dart';
import 'package:emad_client/services/pdf/save_pdf.dart';
import 'package:emad_client/services/shared_preferences_singleton.dart';
import 'package:emad_client/widget/custom_appbar.dart';
import 'package:emad_client/widget/dialogs/generic_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../services/cloud/firebase_cloud_storage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final FirebaseCloudStorage _imagesService;
  final TextEditingController _textEditingController = TextEditingController();
  final HistoryController _historyController = HistoryController();
  final NetworkController _networkController = NetworkController();
  final SpeechToText _speechToText = SpeechToText();
  final ImageGeneratorController _imageGeneratorController =
      ImageGeneratorController();
  bool _isListening = false;
  List<ImageData> generatedImages = []; // Usa ImageData invece di URL
  bool isLoadingImages = false;
  bool violence = false;
  bool sex = false;
  bool _textCorrection = false;
  late Language _language;
  late PdfGenerator _pdfGenerator;
  String _prompt = "";
  bool isGeneratingPDF = false;

  String _backendUrl = "";

  @override
  void initState() {
    super.initState();
    _imagesService = FirebaseCloudStorage();
    _speechToText.initialize();
    _historyController.init();
    _pdfGenerator = PdfGenerator();
  }

  void _checkPreferences() {
    sex = SharedPreferencesSingleton.instance.getSexFlag() ?? false;
    dev.log("Sex: $sex");
    violence = SharedPreferencesSingleton.instance.getViolenceFlag() ?? false;
    dev.log("Violence: $violence");
    _language = SharedPreferencesSingleton.instance.getLanguage();
    dev.log("Language: $_language");
    _textCorrection =
        SharedPreferencesSingleton.instance.getTextCorrectionFlag() ?? false;
    dev.log("Text correction: $_textCorrection");
    _backendUrl =
        SharedPreferencesSingleton.instance.getBackendUrl() ?? ApiService.url;
    ApiService.setUrl(_backendUrl);
    dev.log("Backend URL: $_backendUrl");
  }

  Future<void> _generateImages(BuildContext context) async {
    final prompt = _textEditingController.text;
    _prompt = prompt;
    if (prompt.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.loc.insert_text)),
      );
      return;
    }

    setState(() {
      isLoadingImages = true;
      generatedImages = [];
    });

    try {
      bool status = await _networkController.checkConnection();
      if (!status) {
        Get.toNamed('/no_connection');
        return;
      }

      _checkPreferences();

      final (images, fixed_text) =
          await _imageGeneratorController.generateImagesFromPrompt(
              url: _backendUrl,
              sex: sex,
              violence: violence,
              prompt: prompt,
              language: _language,
              textCorrection: _textCorrection);

      setState(() {
        generatedImages = images; // Aggiorna con la lista di ImageData
        if (fixed_text != null) {
          _prompt = fixed_text;
          _textEditingController.text = fixed_text;
        }
      });

      var history_entry =
          HistoryEntry(fixed_text == null ? prompt : fixed_text, _language);
      _historyController.addToHistory(history_entry);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${context.loc.error_gen_image}: $e")),
      );
    } finally {
      setState(() {
        isLoadingImages = false;
      });
    }
  }

  Future<void> _generateImagesFromHistory(int index) async {
    setState(() {
      isLoadingImages = true;
      generatedImages = [];
    });

    try {
      bool status = await _networkController.checkConnection();
      if (!status) {
        Get.toNamed('/no_connection');
        return;
      }

      _checkPreferences();

      //prendi il testo dalla cronologia
      final history_entry = _historyController.getHistory().elementAt(index);
      _prompt = history_entry.text;
      _language = history_entry.language;
      SharedPreferencesSingleton.instance.setLanguage(_language);

      final (images, fixed_text) =
          await _imageGeneratorController.generateImagesFromPrompt(
              url: _backendUrl,
              sex: sex,
              violence: violence,
              prompt: history_entry.text,
              language: history_entry.language,
              textCorrection: _textCorrection);

      setState(() {
        generatedImages = images; // Aggiorna con la lista di ImageData
        if (fixed_text != null) {
          _prompt = fixed_text;
          _textEditingController.text = fixed_text;
        }
      });

      var new_history_entry =
          HistoryEntry(fixed_text == null ? _prompt : fixed_text, _language);
      _historyController.addToHistory(new_history_entry);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${context.loc.error_gen_image}: $e")),
      );
    } finally {
      setState(() {
        isLoadingImages = false;
      });
    }
  }

  void _uploadImage(BuildContext context, ImageData imageData) async {
    final image = await ImagePicker().pickMedia(imageQuality: 25);
    if (image == null) {
      return;
    }
    _imagesService.addImage(
      userId: FirebaseAuth.instance.currentUser!.uid,
      keyword: imageData.keyword,
      base64: base64Encode((await image.readAsBytes()).toList()),
    );

    showGenericDialog(
        context: context,
        title: context.loc.image_uploaded,
        content: '${context.loc.image_uploaded_keyword} "${imageData.keyword}"',
        optionsBuilder: () => {Text("OK"): null});
  }

  void _showCustomModalBottomSheet() {
    final history = _historyController.getHistory();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          widthFactor: 1,
          heightFactor: 0.8,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/icons/history.png",
                  height: 45,
                  width: 45,
                ),
                const SizedBox(height: 8),
                Text(
                  context.loc.history,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                if (history.isNotEmpty)
                  Expanded(
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 10.0,
                        runSpacing: 10.0,
                        children: List.generate(history.length, (index) {
                          return GestureDetector(
                            onTap: () {
                              _generateImagesFromHistory(index);
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withValues(alpha: 0.2),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                history.elementAt(index).language.emoji +
                                    history.elementAt(index).text,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  )
                else
                  Text(
                    context.loc.no_history,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _generateImageUsingAI(
      BuildContext context, String keyword) async {
    TextEditingController promptController = TextEditingController();
    ValueNotifier<Widget> contentNotifier = ValueNotifier(Container());
    ImageData? imageData; // Variabile per memorizzare l'immagine generata
    int style = SharedPreferencesSingleton.instance.getAIstyle() ?? 1;

    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(context.loc.genai),
          content: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ValueListenableBuilder<Widget>(
                    valueListenable: contentNotifier,
                    builder: (context, value, child) {
                      return value;
                    },
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: promptController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      prefixIcon: GestureDetector(
                        onLongPress: () async {
                          if (!_isListening) {
                            bool available = await _speechToText.initialize();
                            if (available) {
                              setState(() => _isListening = true);
                              _speechToText.listen(onResult: (result) {
                                setState(() {
                                  promptController.text =
                                      result.recognizedWords;
                                });
                              });
                            }
                          }
                        },
                        onLongPressUp: () {
                          if (_isListening) {
                            _speechToText.stop();
                            setState(() => _isListening = false);
                          }
                        },
                        child: Icon(
                          Icons.mic,
                          color: _isListening
                              ? Colors.red
                              : const Color(0xFF60A561),
                        ),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () async {
                          if (promptController.text.isNotEmpty) {
                            contentNotifier.value = Center(
                              child: Lottie.asset(
                                  "assets/gifs/lottie_caricamento_ia.json",
                                  width: 200,
                                  height: 200),
                            );
                            try {
                              // Genera l'immagine usando la IA
                              imageData = await _imageGeneratorController
                                  .generateUsingIA(
                                      _imageGeneratorController.concatenaPrompt(
                                          _language, style, promptController),
                                      keyword);

                              // Non sostituire l'immagine finché non viene confermata
                              contentNotifier.value = Image.network(
                                imageData!.url,
                                // Assicurati che imageData non sia null
                                fit: BoxFit.cover,
                                height: 200,
                                width: 200,
                              );
                            } catch (e) {
                              contentNotifier.value = Center(
                                child: Text(
                                  context.loc.error_gen_image,
                                  style: TextStyle(color: Colors.red),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(context.loc.genai_insert)),
                            );
                          }
                        },
                        icon: const Icon(Icons.send, color: Color(0xFF60A561)),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      hintText: context.loc.genai_question,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Annulla la generazione e non sostituire l'immagine
                Navigator.of(dialogContext).pop();
              },
              child: Text(context.loc.close),
            ),
            TextButton(
              onPressed: () {
                if (imageData != null) {
                  setState(() {
                    // Sostituisci o aggiungi l'immagine nella lista
                    int index = generatedImages.indexWhere(
                      (image) => image.keyword == keyword,
                    );
                    if (index != -1) {
                      // Sostituisci l'immagine esistente
                      generatedImages[index] = imageData!;
                    } else {
                      // Aggiungi una nuova immagine
                      generatedImages.add(imageData!);
                    }
                  });
                }

                // Chiudi la finestra di dialogo
                Navigator.of(dialogContext).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Contenitore delle immagini con il testo sopra
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                height:
                    MediaQuery.of(context).size.height * 0.60, // Altezza fissa
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Testo che mostra il numero di immagini generate
                    SizedBox(
                      width: double.infinity,
                      height: 20,
                    ),
                    generatedImages.isNotEmpty
                        ? SizedBox(
                            width: 250.0,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ShaderMask(
                                  shaderCallback: (bounds) =>
                                      const LinearGradient(
                                    colors: [
                                      Colors.black,
                                      Color(0xFF60A561),
                                      Color(0xFF60A561),
                                      Color(0xFF305331),
                                      Color(0xFF305331),
                                    ],
                                  ).createShader(bounds),
                                  blendMode: BlendMode.srcIn,
                                  child: Center(
                                    // Aggiungi Center per centrare il testo
                                    child: DefaultTextStyle(
                                      style: const TextStyle(
                                        fontSize: 20.0, // Dimensione più grande
                                        fontWeight: FontWeight.bold,
                                      ),
                                      child: AnimatedTextKit(
                                        isRepeatingAnimation: false,
                                        animatedTexts: [
                                          TypewriterAnimatedText(
                                            context.loc.images_generated
                                                .replaceAll(
                                                    "%d",
                                                    generatedImages.length
                                                        .toString()),
                                            speed: const Duration(
                                                milliseconds: 150),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                    // Se non ci sono immagini, non mostra nulla

                    // Se le immagini sono in fase di caricamento o non ci sono immagini, mostriamo il messaggio di benvenuto
                    if (generatedImages.isEmpty && !isLoadingImages)
                      SizedBox(
                        width: 250.0,
                        child: ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [
                              Colors.black,
                              Color(0xFF60A561),
                              Color(0xFF60A561),
                              Color(0xFF60A561),
                              Color(0xFF305331),
                              Color(0xFF305331),
                              Color(0xFF305331),
                              Colors.black,
                            ],
                          ).createShader(bounds),
                          blendMode: BlendMode.srcIn,
                          child: DefaultTextStyle(
                            style: const TextStyle(
                                fontSize: 30.0, fontWeight: FontWeight.bold),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 120),
                              child: AnimatedTextKit(
                                isRepeatingAnimation: false,
                                animatedTexts: [
                                  TypewriterAnimatedText(
                                    context.loc.welcome_msg,
                                    speed: const Duration(milliseconds: 200),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    // Mostriamo le immagini se sono state generate
                    else
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                      ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: generatedImages.map((imageData) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  // Mostra la keyword sopra l'immagine
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text(
                                      imageData.keyword.toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  // Mostra l'immagine
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(
                                          0xffeff6ef), // Colore di sfondo
                                      borderRadius: BorderRadius.circular(
                                          15.0), // Raggio degli angoli smussati
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20.0,
                                            bottom: 20.0,
                                            right: 10.0,
                                            left: 10.0),
                                        child: GestureDetector(
                                          onTap: () async {
                                            await mostraSostituisciImmaginePerKeyword(
                                              context: context,
                                              imageData: imageData,
                                              violence: violence,
                                              sex: sex,
                                            );
                                          },
                                          child: ImageKeyword(
                                            imageData: imageData,
                                            imagesService: _imagesService,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                        5, // Distanza tra l'immagine e le icone
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Icona a sinistra
                                      IconButton(
                                          onPressed: () async {
                                            _generateImageUsingAI(
                                                context, imageData.keyword);
                                          },
                                          icon: Image.asset(
                                            "assets/icons/art-and-design.png",
                                            height: 20,
                                            width: 20,
                                          )),
                                      // Icona a destra
                                      Visibility(
                                        visible:
                                            FirebaseAuth.instance.currentUser !=
                                                null,
                                        child: IconButton(
                                          onPressed: () {
                                            _uploadImage(context, imageData);
                                          },
                                          icon: const Icon(
                                              Icons.upload_file_rounded,
                                              color: Color(
                                                  0xFF60A561) // Scelta del colore
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              if (generatedImages.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          isGeneratingPDF = true;
                        });
                        var bytes = await getPDFBytes();
                        setState(() {
                          isGeneratingPDF = false;
                        });
                        await Printing.layoutPdf(
                          onLayout: (PdfPageFormat format) async => bytes,
                        );
                      },
                      child: isGeneratingPDF
                          ? pdfLoading()
                          : Icon(
                              Icons.print,
                              color: Colors.grey,
                              size: 40,
                            ),
                    ),
                    SizedBox(width: 40),
                    if (kIsWeb)
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            isGeneratingPDF = true;
                          });
                          var bytes = await getPDFBytes();
                          setState(() {
                            isGeneratingPDF = false;
                          });

                          SavePDFHelper.savePDF(bytes, _pdfGenerator.fileName);
                        },
                        child: isGeneratingPDF
                            ? pdfLoading()
                            : Icon(
                                Icons.download,
                                color: Colors.green,
                                size: 40,
                              ),
                      ),
                    if (!kIsWeb)
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            isGeneratingPDF = true;
                          });
                          var bytes = await getPDFBytes();
                          setState(() {
                            isGeneratingPDF = false;
                          });
                          Printing.sharePdf(
                              bytes: bytes, filename: _pdfGenerator.fileName);
                        },
                        child: isGeneratingPDF
                            ? pdfLoading()
                            : Icon(
                                Icons.share,
                                color: Colors.green,
                                size: 40,
                              ),
                      ),
                  ],
                ),
              SizedBox(height: 20),

              // Campo di input
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                child: TextField(
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  controller: _textEditingController,
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  onSubmitted: (value) {
                    _generateImages(context);
                  },
                  decoration: InputDecoration(
                    prefixIcon: GestureDetector(
                      onLongPress: () async {
                        if (!_isListening) {
                          bool available = await _speechToText.initialize();
                          if (available) {
                            setState(() => _isListening = true);
                            _speechToText.listen(onResult: (result) {
                              setState(() {
                                _textEditingController.text =
                                    result.recognizedWords;
                              });
                            });
                          }
                        }
                      },
                      onLongPressUp: () {
                        if (_isListening) {
                          _speechToText.stop();
                          setState(() => _isListening = false);
                        }
                      },
                      child: Icon(
                        Icons.mic,
                        color:
                            _isListening ? Colors.red : const Color(0xFF60A561),
                      ),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        // Rimuove il focus dal TextField e chiude la tastiera
                        FocusScope.of(context).requestFocus(FocusNode());
                        _generateImages(context);
                      },
                      icon: const Icon(Icons.send, color: Color(0xFF60A561)),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    hintText: '...',
                  ),
                ),
              ),
              const SizedBox(height: 8.0),

              Column(
                children: [
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin:
                              const EdgeInsets.only(left: 10.0, right: 20.0),
                          child: const Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                        ),
                      ),
                      Text(context.loc.history),
                      Expanded(
                        child: Container(
                          margin:
                              const EdgeInsets.only(left: 20.0, right: 10.0),
                          child: const Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onVerticalDragUpdate: (details) {
                      if (details.primaryDelta! < -10) {
                        _showCustomModalBottomSheet();
                      }
                    },
                    child: IconButton(
                      onPressed: _showCustomModalBottomSheet,
                      icon: const Icon(Icons.keyboard_arrow_up),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> mostraSostituisciImmaginePerKeyword({
    required BuildContext context,
    required ImageData imageData,
    required bool violence,
    required bool sex,
  }) async {
    // Generazione delle immagini
    List<String> images =
        await _imageGeneratorController.generateImagesFromKeyword(
      violence: violence,
      sex: sex,
      keyword: imageData.keyword.toLowerCase(),
      language: _language,
    );

    // Definisci un PageController per controllare lo scorrimento
    PageController pageController = PageController(initialPage: 0);

    // Variabili per gestire la visibilità delle frecce
    bool showLeftArrow = false;
    bool showRightArrow =
        images.length > 1; // Se c'è solo una immagine, le frecce sono nascoste

    // Mostra il pop-up con le immagini
    final selectedImage = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              title: Center(
                  child: Text(
                context.loc.images_found,
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
              content: SizedBox(
                width: double.maxFinite,
                height: 350,
                child: Stack(
                  children: [
                    // Visualizzazione delle immagini
                    PageView.builder(
                      controller: pageController,
                      itemCount: images.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: GestureDetector(
                            onTap: () {
                              // Restituisci l'URL selezionato e chiudi il pop-up
                              Navigator.of(context).pop(images[index]);
                            },
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                width: MediaQuery.of(context)
                                    .size
                                    .width, // Larghezza dell'immagine
                                height: 200,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      10), // Bordo arrotondato per l'immagine
                                  child: Image.network(
                                    images[index],
                                    width: 200,
                                    height: 220,
                                    fit: BoxFit.contain,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      }
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/icons/imageNotFound.png',
                                        width: 200,
                                        // Specifica la larghezza dell'immagine
                                        height: 220,
                                        // Specifica l'altezza dell'immagine
                                        fit: BoxFit
                                            .contain, // Per regolare l'immagine all'interno del box
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      onPageChanged: (int index) {
                        setState(() {
                          // Se siamo sulla prima immagine, nascondiamo la freccia sinistra
                          showLeftArrow = index > 0;
                          // Se siamo sull'ultima immagine, nascondiamo la freccia destra
                          showRightArrow = index < images.length - 1;
                        });
                      },
                    ),

                    // Icona freccia sinistra
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: showLeftArrow
                          ? IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                                size: 40,
                              ),
                              onPressed: () {
                                pageController.previousPage(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                            )
                          : Container(),
                    ),

                    // Icona freccia destra
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: showRightArrow
                          ? IconButton(
                              icon: Icon(
                                Icons.arrow_forward,
                                color: Colors.black,
                                size: 40,
                              ),
                              onPressed: () {
                                pageController.nextPage(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                            )
                          : Container(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(); // Chiude il pop-up senza selezione
                  },
                  child: Text(context.loc.close),
                ),
              ],
            );
          },
        );
      },
    );

    // Aggiorna la lista `generatedImages` con il nuovo URL e keyword selezionati
    if (selectedImage != null) {
      setState(() {
        // Trova l'indice dell'immagine corrente nella lista
        final int index = generatedImages.indexOf(imageData);
        if (index != -1) {
          // Aggiorna l'immagine nella lista
          generatedImages[index] = ImageData(
            url: selectedImage, // Nuovo URL
            keyword: imageData.keyword, // Mantieni la keyword originale
          );
        }
      });
    }
  }

  Future<Uint8List> getPDFBytes() async {
    _pdfGenerator.setGeneratedImages(generatedImages);
    _pdfGenerator.setSentence(_prompt);
    _pdfGenerator.setFilename();
    var bytes = await _pdfGenerator.generatePDF();

    return bytes;
  }

  SizedBox pdfLoading() {
    return SizedBox(
      height: 40,
      width: 40,
      child: CircularProgressIndicator(),
    );
  }
}
