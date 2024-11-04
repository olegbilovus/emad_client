import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoConnection extends StatelessWidget {
  const NoConnection({super.key});

  @override
  Widget build(BuildContext context) {
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
