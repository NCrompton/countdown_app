import 'package:calendar/model/duration_component.dart';
import 'package:calendar/utils/const.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String formateDateStringToStandard() {
    final DateFormat formatter = DateFormat(dateFormat);
    return formatter.format(this);
  }

  String formatToDisplay() {
    final DateFormat formatter = DateFormat(dateDisplayFormat);
    return formatter.format(this);
  }

  String formatToShortDisplay() {
    final DateFormat formatter = DateFormat(dateDisplayShortFormat);
    return formatter.format(this);
  }

  DurationComponent standardDifferenceFromNow(DateTime other) {
    return DurationComponent(duration: (isBefore(other))? 
            other.difference(this):
            difference(other));
  }
}