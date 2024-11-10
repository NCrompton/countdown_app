import 'package:flutter/foundation.dart';

class DateBloc extends ChangeNotifier {
  static final DateBloc _dateBloc = DateBloc.internal();

  DateTime? targetDate;

  DateBloc.internal();

  void init() {}

  void setTargetDate(DateTime targetDate) {
    targetDate = targetDate;
  }

  factory DateBloc() {
    return _dateBloc;
  }
}
