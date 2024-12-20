import 'package:calendar/components/budget_entry_cell.dart';
import 'package:calendar/components/portion_circle.dart';
import 'package:calendar/model/budget_schema.dart';
import 'package:calendar/providers/budget_entry_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetTypePage extends ConsumerStatefulWidget {
  const BudgetTypePage({
    super.key,
    required this.type,
  });

  final BudgetEntryType type;

  @override
  ConsumerState<BudgetTypePage> createState() => _BudgetTypePageState();
}

class _BudgetTypePageState extends ConsumerState<BudgetTypePage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(budgetEntriesProviderProvider(null));
    final width = MediaQuery.of(context).size.width * 0.5;
    final size = Size(width, width);
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Budget Type"),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  widget.type.typeName,
                  style: const TextStyle(
                    fontSize: 24,
                  ),
                )
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue,
                    Colors.purple,
                    Colors.red,
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Expanded(child: SizedBox()),
                  SizedBox(
                    width: width,
                    child: PortionCircle(
                      size: size,
                      percent: 45.5,
                      color: widget.type.color,
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                ] 
              ),
            ),
            Expanded(
              child: switch(state) {
                  AsyncData(:final value) => value.isEmpty 
                    ? const SizedBox()
                    : CupertinoListSection(
                        children: (value.where((v) => v.entryType == widget.type.id)
                          .map((v) =>
                            BudgetEntryCell(entry: v)
                        ).toList()),
                      ),
                  AsyncLoading() => const CircularProgressIndicator(),
                  _ => const Center(child: Text("Encountered error")),
              }
            )
          ],
        ),
      )
    );
  }
}