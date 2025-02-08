import 'dart:developer' as dev;

import 'package:emad_client/extensions/buildcontext/loc.dart';
import 'package:emad_client/services/shared_preferences_singleton.dart';
import 'package:emad_client/widget/custom_appbar_back.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _flagSex = false;
  bool _flagViolence = false;
  bool _textCorrection = false;

  // 1 - Pittogrammi
  // 2 - Realismo
  // 3 - Cartoon
  int _selectedValue = 1;
  String _selectedLanguage = "";

  @override
  void initState() {
    super.initState();
    initPreferences();
  }

  void initPreferences() async {
    await SharedPreferencesSingleton.instance.init();
    setState(() {
      _flagSex = SharedPreferencesSingleton.instance.getSexFlag() ?? false;
      _flagViolence =
          SharedPreferencesSingleton.instance.getViolenceFlag() ?? false;
      _selectedValue = SharedPreferencesSingleton.instance.getAIstyle() ?? 1;
      _selectedLanguage =
          SharedPreferencesSingleton.instance.getLanguage() ?? "it";
      _textCorrection =
          SharedPreferencesSingleton.instance.getTextCorrectionFlag() ?? false;
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
                      _selectedLanguage = "it";
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
                      if (_selectedLanguage == "it")
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
                      _selectedLanguage = "en";
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
                      if (_selectedLanguage == "en")
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
