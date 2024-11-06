import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:emad_client/controller/network_controller.dart';

class NoConnection extends StatelessWidget {
  const NoConnection({super.key});

  @override
  Widget build(BuildContext context) {
    final NetworkController _networkController = Get.find<NetworkController>();

    // Ascolta la connessione
    _networkController
        .getConnectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if (result != ConnectivityResult.none) {
        Get.back();
      }
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Connessione Internet assente",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Lottie.asset("assets/gifs/lottie_no_connection.json"),
            const Text(
              "Sei collegato alla rete?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
