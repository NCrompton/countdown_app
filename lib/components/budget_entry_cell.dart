
import 'package:calendar/components/entry_type_avatar.dart';
import 'package:calendar/components/list_cell.dart';
import 'package:calendar/model/budget_schema.dart';
import 'package:calendar/providers/budget_entry_provider.dart';
import 'package:calendar/utils/const.dart';
import 'package:calendar/utils/date_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetEntryCell extends ConsumerWidget {
  const BudgetEntryCell({super.key, required this.entry, this.onTap});

  final BudgetEntry entry;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(budgetEntryTypeProviderProvider);
    return switch(state) {
      AsyncData(:final value) => ListCell(
        onTap: onTap,
        leftWidget: Text(entry.entryName),
        subLeftWidget: Text(entry.entryTime.formatToDisplay()),
        rightWidget: Text("${entry.price.currency.name.toUpperCase()} ${entry.price.value}", 
          style: TextStyle(color: entry.price.value < 0 ? const Color(negativeColor) : const Color(positiveColor))
        ),
        leading: EntryTypeAvartar(type: value[entry.entryType])
      ),
      _ => const SizedBox(), 
    };
  }
}