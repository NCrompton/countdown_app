import 'package:calendar/model/countdown_data.dart';
import 'package:calendar/model/duration_component.dart';
import 'package:calendar/utils/const.dart';
import 'package:calendar/utils/date_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef DateCellStarCallBack = void Function();
typedef DateCellDeleteCallBack = void Function();
class DateCell extends StatelessWidget {
  final CountdownData data;
  final bool isTarget;
  final GestureTapCallback? onTap;
  final DateCellStarCallBack onStar;
  final DateCellDeleteCallBack onDelete;
  final ValueListenable<Duration> elapseController;

  Color get intervalColor => data.date.isBefore(DateTime.now())
    ? const Color(beforeCountdownColor)
    : const Color(afterCountdownColor);

  const DateCell({
    super.key, 
    required this.data, 
    required this.onStar,
    required this.onDelete,
    required this.elapseController,
    this.isTarget=false, 
    this.onTap,
  });

  Widget _getTimeComponent(String suffix, String num) {
    return Column(
      children: [
        Text(num, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: intervalColor),),
        Text(suffix, style: const TextStyle(fontWeight: FontWeight.w200)),
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: isTarget? const Icon(Icons.star) : const Icon(Icons.star_border),
                  onPressed: onStar,
                ),
                Expanded(child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, right: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(data.name, 
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
                            ),
                          ),
                          GestureDetector(
                            onTap: isTarget ? null : onDelete,
                            child: isTarget? const Icon(Icons.star, color: Colors.grey,) : const Icon(Icons.delete),
                          )
                        ],
                      ),
                    ),
                    ValueListenableBuilder<Duration>(
                      valueListenable: elapseController,
                      builder: (context, _, child) {
                        final i = DurationComponent(duration: 
                          data.date.isAfter(DateTime.now())
                            ? data.date.difference(DateTime.now())
                            : DateTime.now().difference(data.date));
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _getTimeComponent("Days", i.days.toString()),
                            _getTimeComponent("Hours", i.hours.toString()),
                            _getTimeComponent("Minutes", i.minutes.toString()),
                            _getTimeComponent("Seconds", i.seconds.toString()),
                          ],
                        );
                      }
                    ),
                    Center(
                      child: Text("Target: ${data.date.formatToStandard()}",
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
}

