import 'package:calendar/components/list_cell.dart';
import 'package:calendar/layout/floating_bottom_drawer.dart';
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
  final BudgetThread thread;
  const BudgetThreadPage({super.key, required this.thread});

  @override
  ConsumerState<BudgetThreadPage> createState() => _BudgetThreadPageState();
}

class _BudgetThreadPageState extends ConsumerState<BudgetThreadPage> {

  @override
  Widget build(BuildContext context) {
    // final budgets = widget.thread.budgets;
    final budgets = ref.watch(budgetThreadEntryProviderProvider(widget.thread.id)).value;
    return FloatingBottomDrawerPage(
      heightPortion: 0.7,
      drawerChild: (dismiss) => AddBudgetEntryPage(thread: widget.thread, dismiss: dismiss),
      builder: (context, visibilityController) {
        return CustomScrollView(
                    slivers: [
                      CupertinoSliverRefreshControl(
                        onRefresh: () async {
                        },
                      ),
                      SliverToBoxAdapter(
                        child: CupertinoListSection(
                              children: [...budgets?.map((entry) {
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
                                }).toList() ?? [],
                                BudgetEntryAddCell(onTap: () => visibilityController.setVisibility(true)), 
                              ]
                            ),
                      ),
                    ],
                  );
      }, 
    );
  }
}

class BudgetEntryCell extends StatelessWidget {
  const BudgetEntryCell({super.key, required this.entry, this.onTap});

  final BudgetEntry entry;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListCell(
      onTap: onTap,
      leftWidget: Text(entry.entryName),
      subLeftWidget: Text(entry.entryTime.formatToDisplay()),
      rightWidget: Text("${entry.price.currency.name.toUpperCase()} ${entry.price.value}", 
        style: TextStyle(color: entry.price.value < 0 ? const Color(negativeColor) : const Color(positiveColor))
      ),
      leading: CircleAvatar(
        backgroundColor: entry.entryType.color,
        foregroundColor: entry.entryType.color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
        child: Icon(entry.entryType.icon),
      ),
    );
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