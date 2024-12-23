import 'dart:ui';

extension ListExtension<T> on List<T> {
  Iterable<K> mapIndexed<K>(K Function(T, int) callback) {
    List<K> tmp = [];
    for (var i = 0; i < length; i++) {
      tmp.add(callback(this[i], i));
    }
    return tmp;
  }
}

extension ColorUtil on Color {
  bool isLightColor() {
    return computeLuminance() > 0.5;
  }
}