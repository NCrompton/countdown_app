import 'package:calendar/utils/const.dart';
import 'package:calendar/utils/widget.dart';
import 'package:flutter/cupertino.dart';

class TimeFormatPicker extends StatefulWidget {
  final bool featureEnable = customIntervalFormatEnable;

  const TimeFormatPicker({super.key});

  @override
  State<TimeFormatPicker> createState() => _TimeFormatPickerState();
}

class _TimeFormatPickerState extends State<TimeFormatPicker> {
  bool day = false;
  bool hour = false;
  bool minute = false;
  bool second = false;

  void _setPreference(bool day, bool hour, bool minute, bool second) {
    setState(() {
      this.day = day;
      this.hour = hour;
      this.minute = minute;
      this.second = second;
    });
    NativeWidgetManager().countdownTimeFormat(day, hour, minute, second);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.featureEnable) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CupertinoCheckbox(value: day, onChanged: (_) => _setPreference(!day, hour, minute, second)),
          const Text("Day"),
          CupertinoCheckbox(value: hour, onChanged: (_) => _setPreference(day, !hour, minute, second)),
          const Text("Hour"),
          CupertinoCheckbox(value: minute, onChanged: (_) => _setPreference(day, hour, !minute, second)),
          const Text("Minute"),
          CupertinoCheckbox(value: second, onChanged: (_) => _setPreference(day, hour, minute, !second),),
          const Text("Second"),
        ],
      )
    );
  }
}