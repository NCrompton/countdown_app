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
      child: CircleIcon(
        backgroundColor: type.color,
        iconColor: type.color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
        icon: type.icon
      )
    );
  }
}

class CircleIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color iconColor;
  final Color backgroundColor;

  const CircleIcon({
    Key? key,
    required this.icon,
    this.size = 40.0,
    this.iconColor = Colors.white,
    this.backgroundColor = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          icon,
          color: iconColor,
          size: size * 0.6, // Adjust icon size relative to the circle
        ),
      ),
    );
  }
}
