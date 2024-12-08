
import 'package:calendar/utils/view_helper.dart';
import 'package:flutter/material.dart';

class PickerWrapper extends StatelessWidget {
  final String text;
  final Widget picker;

  const PickerWrapper({
    super.key,
    required this.text,
    required this.picker,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showCupertinoPickerPopup(
        context: context, 
        picker: picker,
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(12),
        child: Text(text)
      )
    );
  }
}