import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:emad_client/controller/history_controller.dart';
import 'package:emad_client/extensions/buildcontext/loc.dart';
import 'package:emad_client/widget/custom_appbar.dart';
import 'package:emad_client/controller/network_controller.dart';
import 'package:get/get.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textEditingController = TextEditingController();
  final HistoryController _historyController = HistoryController();
  final NetworkController _networkController = NetworkController();

  @override
  void initState() {
    super.initState();
    _historyController.init();
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
                // Lista della cronologia
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
                  const Text(
                    "Nessuna cronologia disponibile",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
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
              Container(
                height: MediaQuery.of(context).size.height * 0.35,
                alignment: Alignment.bottomCenter,
                child: SizedBox(
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
                ),
              ),
              const SizedBox(height: 240.0),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                child: TextField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: GestureDetector(
                        onLongPress: () {
                          // attiva il "speech to text"
                        },
                        child: const Icon(Icons.mic, color: Color(0xFF60A561)),
                      ),
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: IconButton(
                        onPressed: () async {
                          //ottiene la cronologia
                          _historyController.getHistory();
                          //aggiunge la frase alla cronologia
                          _historyController
                              .addToHistory(_textEditingController.text);

                          //controllo sulla connessione
                          bool status =
                              await _networkController.checkConnection();
                          if (status == false) {
                            print("Stato connessione: $status");
                            Get.toNamed('/no_connection');
                          }
                        },
                        icon: const Icon(Icons.send, color: Color(0xFF60A561)),
                      ),
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
}
