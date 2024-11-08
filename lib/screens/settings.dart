import 'package:emad_client/extensions/buildcontext/loc.dart';
import 'package:emad_client/widget/custom_appbar_back.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbarBack(
        title: context.loc.settings,
      ),
    );
  }
}
