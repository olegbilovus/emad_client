import 'dart:developer' as dev;

import 'package:emad_client/extensions/buildcontext/loc.dart';
import 'package:emad_client/services/api_service.dart';
import 'package:emad_client/services/enum.dart';
import 'package:emad_client/services/shared_preferences_singleton.dart';
import 'package:emad_client/widget/custom_appbar_back.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _flagSex = false;
  bool _flagViolence = false;
  bool _textCorrection = false;
  String _version = "";
  int _clickCount = 0;
  final TextEditingController _urlController = TextEditingController();

  // 1 - Pittogrammi
  // 2 - Realismo
  // 3 - Cartoon
  int _selectedValue = 1;
  Language _selectedLanguage = Language.it;

  @override
  void initState() {
    super.initState();
    initPreferences();
    _getVersion();
    _urlController.text =
        SharedPreferencesSingleton.instance.getBackendUrl() ?? "";
  }

  void _getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
    });
  }

  void initPreferences() async {
    await SharedPreferencesSingleton.instance.init();
    setState(() {
      _flagSex = SharedPreferencesSingleton.instance.getSexFlag() ?? false;
      _flagViolence =
          SharedPreferencesSingleton.instance.getViolenceFlag() ?? false;
      _selectedValue = SharedPreferencesSingleton.instance.getAIstyle() ?? 1;
      _selectedLanguage = SharedPreferencesSingleton.instance.getLanguage();
      _textCorrection =
          SharedPreferencesSingleton.instance.getTextCorrectionFlag() ?? false;
      _urlController.text =
          SharedPreferencesSingleton.instance.getBackendUrl() ?? ApiService.url;
    });
  }

  void mostraBottomSheet(String title, String text, String urlIcon) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Image.asset(
                    urlIcon,
                    height: 80,
                    width: 80,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                  ),
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
      appBar: CustomAppbarBack(
        title: context.loc.settings,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  context.loc.parental_control,
                  style: TextStyle(fontSize: 20),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GestureDetector(
                    child: Icon(
                      Icons.info_outline,
                      color: Color(0xFF60A561),
                    ),
                    onTap: () {
                      mostraBottomSheet(
                          context.loc.parental_control_1,
                          context.loc.parental_control_2,
                          "assets/icons/kid.png");
                    },
                  ),
                ),
                Spacer(),
                Switch(
                  // This bool value toggles the switch.
                  value: _flagSex && _flagViolence,
                  activeColor: Color(0xFF60A561),
                  onChanged: (bool value) {
                    // This is called when the user toggles the switch.
                    setState(() {
                      _flagSex = value;
                      _flagViolence = value;
                      SharedPreferencesSingleton.instance.setSexFlag(value);
                      SharedPreferencesSingleton.instance
                          .setViolenceFlag(value);
                    });
                  },
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Divider(
              height: 1,
              color: Colors.grey,
              thickness: 1.0,
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Text(
                  context.loc.ai_style,
                  style: TextStyle(fontSize: 20),
                ),
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(
                      Icons.info_outline,
                      color: Color(0xFF60A561),
                    ),
                  ),
                  onTap: () {
                    mostraBottomSheet(
                      context.loc.ai_style_1,
                      context.loc.ai_style_2,
                      "assets/icons/ai.png",
                    );
                  },
                ),
              ],
            ),
            Column(
              children: [
                ListTile(
                  title: Text(
                    context.loc.ai_style_pictogram,
                    style: TextStyle(fontSize: 16),
                  ),
                  leading: Radio<int>(
                    value: 1,
                    groupValue: _selectedValue,
                    onChanged: (value) {
                      setState(() {
                        _selectedValue = value!;
                        dev.log("Button value: $value");
                        SharedPreferencesSingleton.instance
                            .setAIstyle(_selectedValue);
                      });
                    },
                  ),
                ),
                ListTile(
                  title: Text(
                    context.loc.ai_style_realism,
                    style: TextStyle(fontSize: 16),
                  ),
                  leading: Radio<int>(
                    value: 2,
                    groupValue: _selectedValue,
                    onChanged: (value) {
                      setState(() {
                        _selectedValue = value!;
                        dev.log("Button value: $value");
                        SharedPreferencesSingleton.instance
                            .setAIstyle(_selectedValue);
                      });
                    },
                  ),
                ),
                ListTile(
                  title: Text(context.loc.ai_style_cartoon,
                      style: TextStyle(fontSize: 16)),
                  leading: Radio<int>(
                    value: 3,
                    groupValue: _selectedValue,
                    onChanged: (value) {
                      setState(() {
                        _selectedValue = value!;
                        dev.log("Button value: $value");
                        SharedPreferencesSingleton.instance
                            .setAIstyle(_selectedValue);
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Divider(
              height: 1,
              color: Colors.grey,
              thickness: 1.0,
            ),
            SizedBox(
              height: 16,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Text(
                        context.loc.chat_language,
                        style: TextStyle(fontSize: 20),
                      ),
                      GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(
                            Icons.info_outline,
                            color: Color(0xFF60A561),
                          ),
                        ),
                        onTap: () {
                          mostraBottomSheet(
                            context.loc.chat_language_1,
                            context.loc.chat_language_2,
                            "assets/icons/languages.png",
                          );
                        },
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedLanguage = Language.it;
                      SharedPreferencesSingleton.instance
                          .setLanguage(_selectedLanguage);
                    });
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/icons/italy.png",
                        height: 40,
                        width: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          context.loc.chat_language_it,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      if (_selectedLanguage == Language.it)
                        Icon(
                          Icons.check_circle,
                          color: Color(0xFF60A561),
                        ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedLanguage = Language.en;
                      SharedPreferencesSingleton.instance
                          .setLanguage(_selectedLanguage);
                    });
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/icons/united-kingdom.png",
                        height: 40,
                        width: 40,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          context.loc.chat_language_en,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      if (_selectedLanguage == Language.en)
                        Icon(
                          Icons.check_circle,
                          color: Color(0xFF60A561),
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
            Divider(
              height: 1,
              color: Colors.grey,
              thickness: 1.0,
            ),
            Row(
              children: [
                Text(
                  context.loc.ai_text_correction,
                  style: TextStyle(fontSize: 20),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GestureDetector(
                    child: Icon(
                      Icons.info_outline,
                      color: Color(0xFF60A561),
                    ),
                    onTap: () {
                      mostraBottomSheet(
                          context.loc.ai_text_correction_1,
                          context.loc.ai_text_correction_2,
                          "assets/icons/Notes-bro.png");
                    },
                  ),
                ),
                Spacer(),
                Switch(
                  // This bool value toggles the switch.
                  value: _textCorrection,
                  activeColor: Color(0xFF60A561),
                  onChanged: (bool value) {
                    // This is called when the user toggles the switch.
                    setState(() {
                      _textCorrection = value;
                      SharedPreferencesSingleton.instance
                          .setTextCorrectionFlag(value);
                    });
                  },
                ),
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: _handleVersionClick,
              child: Text(
                'Version: $_version',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleVersionClick() {
    setState(() {
      _clickCount++;
      if (_clickCount >= 5) {
        _showUrlPopup();
      }
    });
  }

  void _showUrlPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Backend URL'),
          content: TextField(
            controller: _urlController,
            decoration: InputDecoration(
              labelText: 'Backend URL',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle the URL submission here
                var url = _urlController.text;
                SharedPreferencesSingleton.instance.setBackendUrl(url);
                ApiService.setUrl(url);
                dev.log("Backend URL: $url");
                Navigator.of(context).pop();
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
