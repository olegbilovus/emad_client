import 'package:emad_client/extensions/buildcontext/loc.dart';
import 'package:emad_client/widget/custom_appbar_back.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String _nomeUtente = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbarBack(title: "${context.loc.welcome_back} $_nomeUtente"),
      body: Column(),
    );
  }
}
