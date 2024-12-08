import 'package:calendar/model/budget_schema.dart';
import 'package:calendar/utils/date_util.dart';
import 'package:flutter/material.dart';

class BudgetThreadCell extends StatelessWidget {
  final BudgetThread thread;
  final GestureTapCallback? onTap;

  const BudgetThreadCell({super.key, required this.thread, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    thread.threadName, 
                    style: const TextStyle(fontSize: 18),),
                  Text("${thread.budgets.first.entryTime.formatToShortDisplay()} - ${thread.budgets.last.entryTime.formatToShortDisplay()}"),
                ],
              ),
              const Icon(Icons.arrow_forward),
            ],
          )
        )
      )
    );
  }
}