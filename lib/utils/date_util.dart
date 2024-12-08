import 'package:calendar/model/duration_component.dart';
import 'package:intl/intl.dart';

const String dateFormat = "yyyy-MM-dd HH:mm:ss";
const String dateShortFormat = "yyyy-MM-dd";
const String dateDisplayFormat = "dd MMM y HH:mm";
const String dateDisplayShortFormat = "dd MMM y";

extension DateTimeExtension on DateTime {
  String formatToStandard() {
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
  
  String formatToShortStandard() {
    final DateFormat formatter = DateFormat(dateDisplayShortFormat);
    return formatter.format(this);
  }

  DurationComponent standardDifferenceFromNow(DateTime other) {
    return DurationComponent(duration: (isBefore(other))? 
            other.difference(this):
            difference(other));
  }
}