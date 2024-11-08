import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:emad_client/controller/network_controller.dart';
import 'package:emad_client/extensions/buildcontext/loc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class NoConnection extends StatelessWidget {
  const NoConnection({super.key});

  @override
  Widget build(BuildContext context) {
    final NetworkController networkController = Get.find<NetworkController>();

    // Ascolta la connessione
    networkController
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
            Text(
              context.loc.no_network,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Lottie.asset("assets/gifs/lottie_no_connection.json"),
            Text(
              context.loc.no_network_q,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
