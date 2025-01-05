import 'package:calendar/components/budget_entry_cell.dart';
import 'package:calendar/components/floating_menu.dart';
import 'package:calendar/model/budget_schema.dart';
import 'package:calendar/pages/add_budget_entry_page.dart';
import 'package:calendar/providers/budget_thread_provider.dart';
import 'package:calendar/screens/budget_entry_page.dart';
import 'package:calendar/providers/budget_entry_provider.dart';
import 'package:calendar/utils/route_transition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

typedef ThreadDisplayStruct = Map<String, List<BudgetEntry>>;

class BudgetThreadPage extends ConsumerStatefulWidget {
  final BudgetThread? thread;
  const BudgetThreadPage({super.key, this.thread});

  @override
  ConsumerState<BudgetThreadPage> createState() => _BudgetThreadPageState();
}

class _BudgetThreadPageState extends ConsumerState<BudgetThreadPage> {
  final ValueNotifier<bool> _isByMonth = ValueNotifier(true);
  DateFormat get formatter => _isByMonth.value ? DateFormat("MMM y") : DateFormat("dd MMM y");

  void _showAddEntryPopup() {
    showCupertinoModalPopup(
      context: context, 
      builder: (BuildContext context) {
        return 
          CupertinoPopupSurface(
            isSurfacePainted: true,
            child: Container(
              height: 500,
              color: CupertinoColors.systemBackground,
              child: AddBudgetEntryPage(thread: widget.thread, dismiss: (){
                Navigator.of(context).pop();
              })
            ),
          );
      }
    );
  }

  void _updateTargetThread() async {
    final targetThread = await ref.read(targetThreadProvider.future);
    ref.read(targetThreadProvider.notifier)
      .updateTargetThread(widget.thread?.id == targetThread ? null : widget.thread!.id);
  }

  ThreadDisplayStruct _renderDisplayStruct(List<BudgetEntry> entryList) {
    Map<String, List<BudgetEntry>> struct = <String, List<BudgetEntry>>{};
    for (var e in entryList) {
      final name = formatter.format(e.entryTime);
      if (struct[name] == null) {
        struct[name] = [e];
      } else {
        struct[name]!.add(e);
      }
    }
    return struct;
  }

  Widget _buildEntryList(List<BudgetEntry> entries) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: CupertinoColors.systemGroupedBackground,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ValueListenableBuilder<bool>(
        valueListenable: _isByMonth,
        builder: (context, isByMonth, child) {
          final e = _renderDisplayStruct(entries).entries.toList();
          return ListView.builder(
            itemCount: e.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) return BudgetEntryAddCell(onTap: _showAddEntryPopup);
              return CupertinoListSection(
                header: Text(e[index - 1].key),
                children: [...e[index - 1].value.map((entry) {
                  return Builder(
                    builder: (context) {
                      return BudgetEntryCell(
                        onTap: () {
                          openPageSide(
                            context, 
                            BudgetEntryPage(entry: entry),
                          );
                        },
                        entry: entry,
                      );
                    },
                  );
                }).toList()]
              );
            }
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(budgetEntriesProviderProvider(widget.thread?.id));
    final targetThread = ref.watch(targetThreadProvider);
    return SafeArea(
      child: Stack(
        children: [
          switch(state) {
            AsyncData(:final value) => _buildEntryList(value),
            AsyncLoading() => const Center(child: CircularProgressIndicator()),
            _ => const SizedBox(),
          },
          FloatingMenu(
            menuItems: [
              if (widget.thread != null)
                ...[
                  FloatingMenuItem( 
                    icon: Icons.delete, 
                    color: CupertinoColors.destructiveRed,
                    onTap: () {
                      ref.read(budgetThreadProviderProvider.notifier).deleteBudgetThread(widget.thread!);
                      Navigator.of(context).pop();
                    },
                  ),
                  switch (targetThread) {
                    AsyncData(:final value) => 
                      FloatingMenuItem( 
                        icon: widget.thread!.id == value ? Icons.close : Icons.star, 
                        onTap: _updateTargetThread,
                      ),
                    _ =>
                      const FloatingMenuItem( 
                        icon: Icons.star, 
                      ),
                  }
                ],
              FloatingMenuItem( 
                icon: Icons.swap_calls, 
                onTap: () =>
                  setState(() => _isByMonth.value = !_isByMonth.value)
              ),
            ]
          )
        ]
      ),
    );
  }
}

class BudgetEntryAddCell extends StatelessWidget {
  final GestureTapCallback? onTap;

  const BudgetEntryAddCell({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16), 
        child: const Center(child: Icon(Icons.add))
      )
    );
  }
}