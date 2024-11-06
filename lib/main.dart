import 'package:emad_client/controller/network_controller.dart';
import 'package:emad_client/dependency_injection.dart';
import 'package:emad_client/screens/no_connection.dart';
import 'package:emad_client/screens/settings.dart';
import 'package:emad_client/widget/custom_appbar.dart';
import 'package:flutter/material.dart';
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
      title: 'CAApp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Ciao, cosa vuoi generare"),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '...',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
