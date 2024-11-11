import 'dart:collection';
import 'package:emad_client/services/shared_preferences_singleton.dart';

class HistoryController {
  final String _key = "cronologia";
  final int maxSize;
  Queue<String> _historyQueue = Queue<String>();

  HistoryController({this.maxSize = 10});

  // Inizializza la cronologia caricando gli elementi da SharedPreferences
  Future<void> init() async {
    await SharedPreferencesSingleton.instance.init();

    // Carica la cronologia da SharedPreferences
    _historyQueue = SharedPreferencesSingleton.instance.getQueue(_key);

    // Se la coda è vuota, si inizializza a vuota
    if (_historyQueue.isEmpty) {
      _historyQueue = Queue<String>();

      await SharedPreferencesSingleton.instance.setQueue(_key, _historyQueue);
    }
  }

  // Aggiunge un item alla cronologia
  Future<void> addToHistory(String item) async {
    // Controllo sui duplicati
    if (_historyQueue.contains(item)) {
      return;
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
  Queue<String> getHistory() {
    return _historyQueue;
  }

  // Cancella tutta la cronologia
  Future<void> clearHistory() async {
    _historyQueue.clear();
    await SharedPreferencesSingleton.instance.remove(_key);
  }
}
