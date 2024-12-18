import 'package:calendar/components/list_cell.dart';
import 'package:calendar/model/budget_schema.dart';
import 'package:calendar/pages/add_budget_entry_page.dart';
import 'package:calendar/screens/budget_entry_page.dart';
import 'package:calendar/providers/budget_entry_provider.dart';
import 'package:calendar/utils/const.dart';
import 'package:calendar/utils/date_util.dart';
import 'package:calendar/utils/route_transition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetThreadPage extends ConsumerStatefulWidget {
  final BudgetThread? thread;
  const BudgetThreadPage({super.key, this.thread});

  @override
  ConsumerState<BudgetThreadPage> createState() => _BudgetThreadPageState();
}

class _BudgetThreadPageState extends ConsumerState<BudgetThreadPage> {

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

  @override
  Widget build(BuildContext context) {
    final state = (widget.thread != null)
      ? ref.watch(budgetThreadEntryProviderProvider(widget.thread!.id))
      : ref.watch(budgetEntriesProviderProvider);
    return CustomScrollView(
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: () => 
            (widget.thread != null)
              ? ref.refresh(budgetThreadEntryProviderProvider(widget.thread!.id).future)
              : ref.refresh(budgetEntriesProviderProvider.future),
        ),
        SliverToBoxAdapter(
          child: switch(state) {
            AsyncData(:final value) => 
              CupertinoListSection(
                children: [...value.map((entry) {
                  entry.thread.value = widget.thread;
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
                }).toList(),
                // BudgetEntryAddCell(onTap: () => visibilityController.setVisibility(true)), 
                BudgetEntryAddCell(onTap: () => _showAddEntryPopup()), 
              ]
            ),
            AsyncLoading() => const Center(child: CircularProgressIndicator()),
            _ => const SizedBox(),
          }
        ),
      ],
    );
  }
}

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
        leading: CircleAvatar(
          backgroundColor: value[entry.entryType].color,
          foregroundColor: value[entry.entryType].color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
          child: Icon(value[entry.entryType].icon),
        ),
      ),
      _ => const SizedBox(), 
    };
  }
}

class BudgetEntryAddCell extends StatelessWidget {
  final GestureTapCallback? onTap;

  const BudgetEntryAddCell({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: const Padding(
        padding: EdgeInsets.all(16), 
        child: Center(child: Icon(Icons.add))
      )
    );
  }
}