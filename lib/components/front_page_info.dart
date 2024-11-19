import 'dart:async';

import 'package:calendar/model/countdown_data.dart';
import 'package:calendar/model/duration_component.dart';
import 'package:calendar/providers/date_provider.dart';
import 'package:calendar/screens/date_list.dart';
import 'package:calendar/utils/date_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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
      if (targetDate == null) return;

      now = DateTime.now();
      isTargetBeforeNow = targetDate!.date.isBefore(now);
      
      diffDate = targetDate!.date.standardDifferenceFromNow(now);
      
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
          CupertinoButton.filled(
            onPressed: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => const DateListPage()));
            },
            alignment: Alignment.center,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Pick a Date", style: TextStyle(fontSize: 18)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.0),
                  child: Icon(Icons.arrow_right_sharp, size: 32,),
                ),
              ]
            ),
          )
        ],
      ),
    );
  }
}
