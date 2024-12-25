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
  double portion = 0;
  double typeSpending = 0;

  @override
  void initState() {
    super.initState();
    getPortion();
  }

  void getPortion() async {
    await ref.read(budgetEntriesProviderProvider(null).future);
    final totalSpending = await ref.read(budgetEntriesProviderProvider(null).notifier).exchangedTotalSpending();
    final typeSpending = await ref.read(budgetEntriesProviderProvider(null).notifier).exchangeEntryTypeTotal(widget.type);
    setState(() {
      this.typeSpending = typeSpending;
      portion = 100 * typeSpending / totalSpending;
    });
  }

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
        child: ListView(
          children: [
            // header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.type.typeName,
                    style: const TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "HKD ${typeSpending.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    )
                  ),
                ]
              ),
            ),
        
            // Portion graph
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
                      percent: portion,
                      color: widget.type.color,
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                ] 
              ),
            ),
        
            // List 
            Expanded(
              child: switch(state) {
                  AsyncData(:final value) => value.isEmpty 
                    ? const SizedBox()
                    : Builder(
                      builder: (context) {
                        return CupertinoListSection(
                            children: (value.where((v) => v.entryType == widget.type.id)
                              .map((v) =>
                                BudgetEntryCell(entry: v)
                            ).toList()),
                          );
                      }
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