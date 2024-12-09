import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// This project's List cell of Cupertino List Section
class ListCell extends StatelessWidget{
  final Widget leftWidget;
  final Widget? subLeftWidget;
  final Widget? rightWidget;
  final Widget? leading;
  final Function()? onTap;
  final IconData? icon;

  const ListCell({
    super.key, 
    required this.leftWidget, 
    this.rightWidget, 
    this.subLeftWidget,
    this.onTap,
    this.leading,
    this.icon,
  });

  Widget? get leadingIcon => icon != null ? Icon(icon) : null;

  Widget? get _leading => 
    leading
    ?? ((icon != null) ? Icon(icon)
    : null);

  Widget? _trailing() {
    if (rightWidget == null && onTap == null) return null;
    return Row(
      children: [
        rightWidget ?? const SizedBox(),
        if (rightWidget != null) const SizedBox(width: 8),
        if (onTap != null) const CupertinoListTileChevron(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      padding: const EdgeInsets.all(16),
      title: leftWidget,
      subtitle: subLeftWidget,
      leading: _leading,
      leadingSize: 40,
      trailing: _trailing(),
      onTap: onTap,
    );
  }
}

/// without using Cupertino List Tile, can be used any where 
class CustomListCell extends StatelessWidget {
  final Widget? leftWidget;
  final Widget? rightWidget;
  final Function()? onTap;

  const CustomListCell({
    super.key, 
    required this.leftWidget, 
    this.rightWidget, 
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: CupertinoColors.systemBackground,
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

/// provide title and subtitle pair as one widget, can be used any where
class CustomCellTitle extends StatelessWidget {
  final String primaryTitle;
  final String? secondaryTitle;
  
  const CustomCellTitle({super.key, required this.primaryTitle, this.secondaryTitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(primaryTitle, style: const TextStyle(fontSize: 20)),
        (secondaryTitle != null) ? Text(secondaryTitle!, style: const TextStyle(fontSize: 14)) : const SizedBox(),
      ],
    );
  }
}