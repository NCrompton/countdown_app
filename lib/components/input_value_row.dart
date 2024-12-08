import 'package:calendar/utils/const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class InputValueRow extends StatelessWidget {
  final String placeholder;
  final TextEditingController controller;
  final IconData? icon;
  final bool enabled;
  final bool isInt;
  final bool isDouble;
  final bool isDateTime;

  const InputValueRow({super.key, 
    required this.controller, 
    required this.placeholder, 
    this.icon,
    bool? enabled,
    bool? isInt,
    bool? isDouble,
    bool? isDateTime,
  }):
    enabled = enabled ?? true,
    isInt = isInt ?? false,
    isDouble = isDouble ?? false,
    isDateTime = isDateTime ?? false;

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
              controller: controller,
              placeholder: placeholder,
              enabled: enabled,
              keyboardType: (isDouble || isInt) ? const TextInputType.numberWithOptions(decimal: true):
                            (isDateTime) ? TextInputType.datetime:
                              TextInputType.text,
              decoration: BoxDecoration(
                                border: Border.all(color: CupertinoColors.systemGrey),
                                borderRadius: BorderRadius.circular(8),
                              ),
              padding: const EdgeInsets.all(12),
              inputFormatters: [
                if (isInt) FilteringTextInputFormatter.allow(RegExp(intRegex)), 
                if (isDouble) FilteringTextInputFormatter.allow(RegExp(doubleRegex)),
                if (isDateTime) FilteringTextInputFormatter.allow(RegExp(nonLeapYearDateRegex + leapYearDateRegex)),
              ],
              suffix: Container(margin: const EdgeInsets.symmetric(horizontal: 12),child: Icon(icon)),

      
    );
  }
}