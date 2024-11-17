import 'package:emad_client/dependency_injection.dart';
import 'package:emad_client/screens/auth/forgot_password.dart';
import 'package:emad_client/screens/auth/signin.dart';
import 'package:emad_client/screens/auth/user_page.dart';
import 'package:emad_client/screens/my_home_page.dart';
import 'package:emad_client/screens/no_connection.dart';
import 'package:emad_client/screens/settings.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
  ]);

  runApp(const MyApp());
  DependencyInjection.init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        ColorScheme.fromSeed(seedColor: const Color(0xFF60A561));
    return GetMaterialApp(
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FirebaseUILocalizations.delegate,
        AppLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,

      title: 'CAApp',
      theme: ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
        appBarTheme: AppBarTheme(
            scrolledUnderElevation: 0, backgroundColor: colorScheme.surface),
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
        GetPage(
          name: '/sign_in',
          page: () => FirebaseAuth.instance.currentUser == null
              ? const SignIn()
              : const UserPage(),
        ),
        GetPage(
          name: '/forgot_password',
          page: () => const ForgotPassword(),
        ),
        GetPage(
          name: '/user_page',
          page: () => const UserPage(),
        ),
      ],
    );
  }
}
