import 'dart:collection';
import 'dart:convert';

import 'package:emad_client/services/enum.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/history_controller.dart';

class SharedPreferencesSingleton {
  SharedPreferencesSingleton._privateConstructor();

  static final SharedPreferencesSingleton _instance =
      SharedPreferencesSingleton._privateConstructor();

  static SharedPreferencesSingleton get instance => _instance;

  static SharedPreferences? _prefs;
  final _sexKey = "sex";
  final _violenceKey = "violence";
  final _aiStyleKey = "AIstyle";
  final _languageKey = "language";
  final _textCorrectionKey = "textCorrection";
  final _backendUrlKey = "backendUrl";

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Salva una stringa
  String? getString(String key) {
    return _prefs?.getString(key);
  }

  Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  // Salva un intero
  Future<void> setInt(String key, int value) async {
    await _prefs?.setInt(key, value);
  }

  int? getInt(String key) {
    return _prefs?.getInt(key);
  }

  // Rimuove una chiave
  Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }

  // Salva una coda come JSON in SharedPreferences
  Future<void> setQueue(String key, Queue<HistoryEntry> queue) async {
    List<HistoryEntry> queueList =
        queue.toList(); // Converti la coda in una lista
    String jsonString = jsonEncode(queueList); // Serializza la lista come JSON
    await _prefs?.setString(key, jsonString);
  }

  // Recupera una coda da SharedPreferences
  Queue<HistoryEntry> getQueue(String key) {
    String? jsonString = _prefs?.getString(key);
    Queue<HistoryEntry> queue = Queue<HistoryEntry>();

    if (jsonString != null) {
      List<dynamic> queueList = jsonDecode(jsonString);
      queueList.forEach((element) {
        queue.add(HistoryEntry.fromJson(jsonDecode(element)));
      });
    }

    return queue;
  }

  //imposta il booleano del campo 'sex' della risposta
  Future<void> setSexFlag(bool flag) async {
    await _prefs?.setBool(_sexKey, flag);
  }

  //ritorna il booleano del campo 'sex' della risposta
  bool? getSexFlag() {
    return _prefs?.getBool(_sexKey);
  }

  //imposta il booleano del campo 'violence' della risposta
  Future<void> setViolenceFlag(bool flag) async {
    await _prefs?.setBool(_violenceKey, flag);
  }

  //ritorna il booleano del campo 'violence' della risposta
  bool? getViolenceFlag() {
    return _prefs?.getBool(_violenceKey);
  }

  Future<void> setAIstyle(int choice) async {
    await _prefs?.setInt(_aiStyleKey, choice);
  }

  int? getAIstyle() {
    return _prefs?.getInt(_aiStyleKey);
  }

  Future<void> setLanguage(Language lan) async {
    await _prefs?.setString(_languageKey, lan.name);
  }

  Language getLanguage() {
    return Language.values.firstWhere(
        (e) => e.name == _prefs?.getString(_languageKey),
        orElse: () => Language.it);
  }

  Future<void> setTextCorrectionFlag(bool flag) async {
    await _prefs?.setBool(_textCorrectionKey, flag);
  }

  bool? getTextCorrectionFlag() {
    return _prefs?.getBool(_textCorrectionKey);
  }

  void setBackendUrl(String text) {
    _prefs?.setString(_backendUrlKey, text);
  }

  String? getBackendUrl() {
    return _prefs?.getString(_backendUrlKey);
  }
}
