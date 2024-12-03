import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListCell extends StatelessWidget{
  final Widget? rightWidget;
  final Widget? leftWidget;
  final Function()? onTap;

  const ListCell({super.key, this.rightWidget, this.leftWidget, this.onTap});

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
              leftWidget ?? const SizedBox(),
              rightWidget ?? const Icon(Icons.arrow_forward),
            ]
          ),
        ),
      ),
    );
  }
}

class CellTitle extends StatelessWidget {
  final String primaryTitle;
  final String? secondaryTitle;
  
  const CellTitle({super.key, required this.primaryTitle, this.secondaryTitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(primaryTitle, style: const TextStyle(fontSize: 18)),
        (secondaryTitle != null) ? Text(secondaryTitle!) : const SizedBox(),
      ],
    );
  }
}