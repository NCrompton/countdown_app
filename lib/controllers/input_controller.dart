import 'package:flutter/material.dart';

class InputController<T> with ChangeNotifier{
  T _value;
  T get value => _value; 

  InputController(T v): _value = v;

  void set(T value) {
    _value = value;
    notifyListeners();
  }

  void silentSet(T value) {
    _value = value;
  }

  @override
  void notifyListeners() => super.notifyListeners();

}