import 'package:calendar/utils/const.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String formateDateStringToStandard() {
    final DateFormat formatter = DateFormat(dateFormat);
    return formatter.format(this);
  }
}