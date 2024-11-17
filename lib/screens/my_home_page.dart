import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:emad_client/controller/image_generator_controller.dart';
import 'package:emad_client/controller/history_controller.dart';
import 'package:emad_client/controller/network_controller.dart';
import 'package:emad_client/extensions/buildcontext/loc.dart';
import 'package:emad_client/widget/custom_appbar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textEditingController = TextEditingController();
  final HistoryController _historyController = HistoryController();
  final NetworkController _networkController = NetworkController();
  final SpeechToText _speechToText = SpeechToText();
  final ImageGeneratorController _imageGeneratorController =
      ImageGeneratorController();
  bool _isListening = false;
  List<String> generatedImageUrls = [];
  bool isLoadingImages = false;
  bool violence = false;
  bool sex = false;
  String language = "it";

  @override
  void initState() {
    super.initState();
    _speechToText.initialize();
    _historyController.init();
  }

  Future<void> _generateImages() async {
    final prompt = _textEditingController.text;
    if (prompt.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Inserisci un testo per generare immagini")),
      );
      return;
    }

    setState(() {
      isLoadingImages = true;
      generatedImageUrls = [];
    });

    try {
      bool status = await _networkController.checkConnection();
      if (!status) {
        Get.toNamed('/no_connection');
        return;
      }

      final urls = await _imageGeneratorController.generateImagesFromPrompt(
          sex: sex, violence: violence, prompt: prompt, language: language);
      setState(() {
        generatedImageUrls = urls;
      });

      _historyController.addToHistory(prompt);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Errore nella generazione delle immagini: $e")),
      );
    } finally {
      setState(() {
        isLoadingImages = false;
      });
    }
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
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              history.elementAt(index),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
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
              // Contenitore delle immagini
              Container(
                height:
                    MediaQuery.of(context).size.height * 0.35, // Altezza fissa
                alignment: Alignment.bottomCenter,
                child: generatedImageUrls.isEmpty && !isLoadingImages
                    ? SizedBox(
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
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: generatedImageUrls.map((url) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(
                                url,
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 150,
                                    height: 150,
                                    color: Colors.grey,
                                    child: const Icon(Icons.broken_image),
                                  );
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
              ),

              // Campo di input
              const SizedBox(height: 240.0),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                child: TextField(
                  controller: _textEditingController,
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
                        _generateImages();
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

              // Storia
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
}
