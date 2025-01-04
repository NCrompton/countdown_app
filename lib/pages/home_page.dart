import 'dart:async';

import 'package:calendar/components/time_format_picker.dart';
import 'package:calendar/model/countdown_data.dart';
import 'package:calendar/model/duration_component.dart';
import 'package:calendar/providers/date_provider.dart';
import 'package:calendar/utils/date_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Home"),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: FrontPageInfo()),
          Center(child: TimeFormatPicker()),
        ],
      ),
    );
  }
}

class FrontPageInfo extends ConsumerStatefulWidget {
  const FrontPageInfo({super.key});

  @override
  ConsumerState<FrontPageInfo> createState() => FrontPageInfoState();
}

class FrontPageInfoState extends ConsumerState<FrontPageInfo> {
  DurationComponent diffDate = DurationComponent(duration: Duration());
  String diffDateString = "";
  CountdownData? targetDate;
  bool isTargetBeforeNow = false;
  DateTime now = DateTime.now();
  final f = NumberFormat("00");
  // ignore: unused_field
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _update();
    });
  }

  void _update() {
    setState(() {
      now = DateTime.now();
      if (targetDate == null) return;

      isTargetBeforeNow = targetDate!.date.isBefore(now);
      
      diffDate = DurationComponent(duration: targetDate!.date.standardDifference(now));
      
      diffDateString =
          "${f.format(diffDate.hours)}:${f.format(diffDate.minutes)}:${(f.format(diffDate.seconds))}";
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateState = ref.watch(asyncDateStateProvider);
    targetDate = dateState.value?.targetDate;

    return Center(
      child: Column(
        children: [
          Text("Today is ${f.format(now.year)}-${f.format(now.month)}-${f.format(now.day)}"),
          Text("Now is ${f.format(now.hour)}:${f.format(now.minute)}:${f.format(now.second)}"),
          Text(
            "Date ${isTargetBeforeNow ? "Since" : "To"} ${dateState.value?.targetDate.toString()}",
          ),
          Text("${diffDate.duration.inDays} Days"),
          Text(diffDateString),
        ],
      ),
    );
  }
}

