import 'package:emad_client/dependency_injection.dart';
import 'package:emad_client/screens/my_home_page.dart';
import 'package:emad_client/screens/no_connection.dart';
import 'package:emad_client/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

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
