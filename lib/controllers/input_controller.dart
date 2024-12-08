import 'package:flutter/material.dart';

class InputController<T> extends ChangeNotifier{
  T value;

  InputController(this.value);

  void set(T value) {
    this.value = value;
    notifyListeners();
  }

  void silentSet(T value) {
    this.value = value;
  }

  @override
  void notifyListeners() => super.notifyListeners();

}