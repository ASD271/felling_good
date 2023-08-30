extension MapGetterExtension<K, V> on Map<K, V> {
  V? getValue(K key, [V? defaultValue]) {
    return containsKey(key) ? this[key] : defaultValue;
  }
}

extension ListExtension<K> on List<K> {
  void addToFirst(K item) {
    if (contains(item)) {
      remove(item);
    }
    insert(0, item);
  }
}
