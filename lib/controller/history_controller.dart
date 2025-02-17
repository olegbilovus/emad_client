import 'dart:collection';
import 'dart:convert';

import 'package:emad_client/services/enum.dart';
import 'package:emad_client/services/shared_preferences_singleton.dart';

class HistoryEntry {
  final String text;
  final Language language;

  HistoryEntry(this.text, this.language);

  @override
  bool operator ==(Object other) {
    if (other is HistoryEntry) {
      return text == other.text && language == other.language;
    }
    return false;
  }

  @override
  int get hashCode => text.hashCode ^ language.hashCode;

  String toJson() {
    return jsonEncode({
      'text': text,
      'language': language.toString().split('.').last,
    });
  }

  factory HistoryEntry.fromJson(Map<String, dynamic> map) {
    return HistoryEntry(
        map['text'],
        Language.values.firstWhere(
            (e) => e.toString().split('.').last == map['language']));
  }
}

class HistoryController {
  final String _key = "cronologia";
  final int maxSize;
  Queue<HistoryEntry> _historyQueue = Queue<HistoryEntry>();

  HistoryController({this.maxSize = 10});

  // Inizializza la cronologia caricando gli elementi da SharedPreferences
  Future<void> init() async {
    await SharedPreferencesSingleton.instance.init();

    // Carica la cronologia da SharedPreferences
    _historyQueue = SharedPreferencesSingleton.instance.getQueue(_key);

    // Se la coda è vuota, si inizializza a vuota
    if (_historyQueue.isEmpty) {
      _historyQueue = Queue<HistoryEntry>();

      await SharedPreferencesSingleton.instance.setQueue(_key, _historyQueue);
    }
  }

  // Aggiunge un item alla cronologia
  Future<void> addToHistory(HistoryEntry item) async {
    // Controllo sui duplicati
    if (_historyQueue.contains(item)) {
      _historyQueue.remove(item);
    }

    // Controllo sulla lunghezza
    if (_historyQueue.length >= maxSize) {
      _historyQueue.removeLast();
    }

    _historyQueue.addFirst(item);

    // Salva la cronologia aggiornata in SharedPreferences
    await SharedPreferencesSingleton.instance.setQueue(_key, _historyQueue);
  }

  // Ritorna l'intera cronologia
  Queue<HistoryEntry> getHistory() {
    return _historyQueue;
  }

  // Cancella tutta la cronologia
  Future<void> clearHistory() async {
    _historyQueue.clear();
    await SharedPreferencesSingleton.instance.remove(_key);
  }
}
