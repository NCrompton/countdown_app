import 'package:flutter/material.dart';

class DateController with ChangeNotifier {

  DateController(this.date); 

  DateTime date = DateTime.now();

  void changeDate(DateTime newDate) {
    date = newDate;
    notifyListeners();
  }

}

class DateCalculatorController extends DateController{

  DateCalculatorController(super.date, this.diff);
  
  int diff = 0;
  DateTime get result => date.add(Duration(days: diff)); 

  void changeDiff(int diff) {
    this.diff = diff;
    notifyListeners();
  }
}