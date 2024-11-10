import 'dart:async';

import 'package:calendar/bloc/date_provider.dart';
import 'package:calendar/screens/home_screen.dart';
import 'package:flutter/material.dart';

class DateText extends StatefulWidget {
  const DateText({super.key});

  @override
  State<StatefulWidget> createState() => DateTextState();
}

class DateTextState extends State<DateText> {
  Duration diffDate = DateTime.utc(2024, 8, 15).difference(DateTime.now());
  String diffTime = "";
  DateTime? targetDate = DateBloc().targetDate;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      _update();
    });
  }

  void _update() {
    setState(() {
      diffDate = DateTime.utc(2024, 8, 16, 9).difference(DateTime.now());
      diffTime =
          "${diffDate.inHours.remainder(24)}:${diffDate.inMinutes.remainder(60)}:${(diffDate.inSeconds.remainder(60))}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            "Date before",
          ),
          Text("${diffDate.inDays} Days"),
          Text(diffTime),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyHomePage()));
              },
              child: const Text("Pick Date"))
        ],
      ),
    );
  }
}
