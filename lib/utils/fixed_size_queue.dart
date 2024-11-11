import 'dart:collection';

class FixedSizeQueue<T> {
  final int maxSize;
  final Queue<T> _queue = Queue<T>();

  FixedSizeQueue(this.maxSize);

  // Aggiunge un elemento alla coda
  void enqueue(T item) {
    if (_queue.length >= maxSize) {
      _queue.removeFirst(); // Rimuove il primo elemento se la coda è piena
    }
    _queue.addLast(item);
  }

  // Rimuove e ritorna l'elemento più vecchio
  T? dequeue() {
    return _queue.isNotEmpty ? _queue.removeFirst() : null;
  }

  // Ritorna il primo elemento senza rimuoverlo
  T? peek() {
    return _queue.isNotEmpty ? _queue.first : null;
  }

  // Ritorna tutti gli elementi della coda come lista
  List<T> toList() {
    return _queue.toList();
  }

  // Verifica se la coda è vuota
  bool get isEmpty => _queue.isEmpty;

  // Verifica se la coda ha raggiunto la dimensione massima
  bool get isFull => _queue.length >= maxSize;

  // Ritorna la dimensione attuale della coda
  int get length => _queue.length;
}
