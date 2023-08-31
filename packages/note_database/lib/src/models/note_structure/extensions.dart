extension MapGetterExtension<K, V> on Map<K, V> {
  T? getValue<T>(K key, [T? defaultValue]) {
    return containsKey(key) ? this[key] as T : defaultValue;
  }

  List<T>? getListValue<T>(K key, [List<T>? defaultValue]) {
    if (this[key] == null) return defaultValue;
    return (this[key]! as List).cast<T>();
  }
}
