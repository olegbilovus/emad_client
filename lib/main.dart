import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:emad_client/dependency_injection.dart';
import 'package:emad_client/extensions/buildcontext/loc.dart';
import 'package:emad_client/screens/no_connection.dart';
import 'package:emad_client/screens/settings.dart';
import 'package:emad_client/widget/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

void main() {
  runApp(const MyApp());
  DependencyInjection.init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      debugShowCheckedModeBanner: false,
      title: 'CAApp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF60A561)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'CAApp'),
      //qua definiamo le pagine dell'app
      getPages: [
        GetPage(
          name: '/',
          page: () => const MyHomePage(title: 'CAApp'),
        ),
        GetPage(
          name: '/settings',
          page: () => const Settings(),
        ),
        GetPage(
          name: '/no_connection',
          page: () => const NoConnection(),
        ),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(),
      body: SingleChildScrollView(
        // Aggiungi un SingleChildScrollView per rendere il layout scrollabile
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
                        repeatForever: true,
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
              const SizedBox(height: 270.0),
              // Aggiungi uno spazio fisso tra il contenuto animato e il TextField
              SizedBox(
                height: MediaQuery.of(context).size.height *
                    0.1, // Altezza per il TextField
                child: TextField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: GestureDetector(
                        onLongPress: () {
                          //attiva il "speech to text"
                        },
                        child: const Icon(Icons.mic, color: Color(0xFF60A561)),
                      ),
                    ),
                    suffixIcon: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Icon(Icons.send, color: Color(0xFF60A561)),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    hintText: '...',
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              // Spazio tra il TextField e il Divider
              // Divider e icona
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
                  IconButton(
                    onPressed: () {
                      WoltModalSheet.show(
                        context: context,
                        pageListBuilder: (bottomSheetContext) => [
                          SliverWoltModalSheetPage(
                            mainContentSliversBuilder: (context) => [
                              SliverToBoxAdapter(
                                child: Center(
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
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                    icon: const Icon(Icons.keyboard_arrow_up),
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
