import 'package:flutter/material.dart';

class VisibilityController with ChangeNotifier {
  bool visible = false;

  VisibilityController (this.visible);

  void toggleVisibility() {
    visible = !visible;
    notifyListeners();
  }

  void setVisibility(bool vis) {
    visible = vis;
    notifyListeners();
  }
}