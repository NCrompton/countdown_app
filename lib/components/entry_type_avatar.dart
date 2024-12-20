import 'package:calendar/model/budget_schema.dart';
import 'package:calendar/screens/budget_type_page.dart';
import 'package:calendar/utils/route_transition.dart';
import 'package:flutter/material.dart';

class EntryTypeAvartar extends StatelessWidget {
  const EntryTypeAvartar({
    super.key,
    required this.type,
  });

  final BudgetEntryType type;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:() => openPageSide(
        context,
        BudgetTypePage(type: type),
      ),
      child: CircleAvatar(
            backgroundColor: type.color,
            foregroundColor: type.color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
            child: Icon(type.icon),
          ),
    );
  }
}