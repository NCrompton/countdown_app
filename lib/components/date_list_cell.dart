import 'dart:async';

import 'package:calendar/model/countdown_data.dart';
import 'package:calendar/model/duration_component.dart';
import 'package:calendar/providers/date_provider.dart';
import 'package:calendar/utils/const.dart';
import 'package:calendar/utils/date_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DateListCell extends ConsumerStatefulWidget {
  final CountdownData data;
  final bool isTarget;
  final GestureTapCallback? onTap;
  // final Function(int) deleteCell;

  const DateListCell({super.key, required this.data, this.isTarget=false, this.onTap});

  @override
  ConsumerState<DateListCell> createState() => DateListCellState(); 
}

class DateListCellState extends ConsumerState<DateListCell> {
  late Color intervalColor;
  late DateTime date;
  late DurationComponent interval;
  late Timer _timer;


  @override
  void initState() {
    super.initState();

    date = widget.data.date;
    interval = date.standardDifferenceFromNow(DateTime.now());
    intervalColor = date.isBefore(DateTime.now())? const Color(beforeCountdownColor): const Color(afterCountdownColor);

    // Align timer updates to occur at the start of each second
    var now = DateTime.now();
    var delay = Duration(seconds: 1) - Duration(milliseconds: now.millisecond);
    
    Future.delayed(delay, () {
      if (mounted) {
        // Start periodic timer aligned to seconds
        _timer = Timer.periodic(const Duration(seconds: 1), (_) {
          if (mounted) {
            setState(() {
              interval = date.standardDifferenceFromNow(DateTime.now());
            });
          }
        });
      }
    });
  }

  void _deleteCell() {
    if (widget.isTarget) return;
    ref.read(asyncDateStateProvider.notifier).removeDate(widget.data.id);
  }

  void _setAsTargetDate() {
    ref.read(asyncDateStateProvider.notifier).setTargetDate(widget.data.id);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: widget.isTarget? Icon(Icons.star) : Icon(Icons.star_border),
                  onPressed: _setAsTargetDate,
                ),
                Expanded(child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.data.toString(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                        IconButton(
                          icon: widget.isTarget? Icon(Icons.star) : Icon(Icons.delete),
                          onPressed: _deleteCell,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _getTimeComponent("Days", interval.days.toString()),
                        _getTimeComponent("Hours", interval.hours.toString()),
                        _getTimeComponent("Minutes", interval.minutes.toString()),
                        _getTimeComponent("Seconds", interval.seconds.toString()),
                      ],
                    ),
                    Center(
                      child: Text("Target: ${date.formateDateStringToStandard()}",
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w200)),
                    )
                  ],
                ))
              ]
            ),
        )
      )
    );
  }

  Widget _getTimeComponent(String suffix, String num) {
    return Column(
      children: [
        Text(num, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: intervalColor),),
        Text(suffix, style: const TextStyle(fontWeight: FontWeight.w200)),
      ]
    );
  }
}

