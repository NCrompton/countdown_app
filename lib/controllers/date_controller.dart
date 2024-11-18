import 'package:flutter/material.dart';

class DateController with ChangeNotifier {

  DateTime date = DateTime.now();

  DateController(this.date); 

  void changeDate(DateTime newDate) {
    date = newDate;
    notifyListeners();
  }

}

class DateCalculatorController extends DateController{
  int diff = 0;
  DateTime get result => date.add(Duration(days: diff)); 

  DateCalculatorController(super.date, this.diff);

  void setNum(int newNum) {
    this.diff = newNum;
    notifyListeners();
  }
}