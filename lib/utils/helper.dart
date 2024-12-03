extension ListExtension<T> on List<T> {
  Iterable<K> mapIndexed<K>(K Function(T, int) callback) {
    List<K> tmp = [];
    for (var i = 0; i < length; i++) {
      tmp.add(callback(this[i], i));
    }
    return tmp;
  }
}