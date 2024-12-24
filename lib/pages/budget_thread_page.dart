import 'package:calendar/components/budget_entry_cell.dart';
import 'package:calendar/components/floating_menu.dart';
import 'package:calendar/model/budget_schema.dart';
import 'package:calendar/pages/add_budget_entry_page.dart';
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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(budgetEntriesProviderProvider(widget.thread?.id));
    return SafeArea(
      child: Stack(
        children: [
          CustomScrollView(
            slivers: [
              CupertinoSliverRefreshControl(
                onRefresh: () => 
                  ref.refresh(budgetEntriesProviderProvider(widget.thread?.id).future)
              ),
              SliverToBoxAdapter(
                child: switch(state) {
                  AsyncData(:final value) => 
                    Container(
                      color: CupertinoColors.systemGroupedBackground,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: ValueListenableBuilder<bool>(
                        valueListenable: _isByMonth,
                        builder: (context, isByMonth, child) {
                          return CupertinoListSection(
                            topMargin: 4,
                            hasLeading: true,
                            margin: const EdgeInsets.only(bottom: 0),
                            backgroundColor: CupertinoColors.systemBackground,
                            header: BudgetEntryAddCell(onTap: () => _showAddEntryPopup()),
                            children: [
                              ..._renderDisplayStruct(value).entries.map((e) {
                                return CupertinoListSection(
                                  header: Text(e.key),
                                  children: [...e.value.map((entry) {
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
                                  }).toList()]
                                );
                              }).toList(),
                              // BudgetEntryAddCell(onTap: () => visibilityController.setVisibility(true)), 
                            ]
                          );
                        }
                      ),
                    ),
                  AsyncLoading() => const Center(child: CircularProgressIndicator()),
                  _ => const SizedBox(),
                }
              ),
            ],
          ),
          FloatingMenu(
            menuItems: [
              if (widget.thread != null)
                ...[FloatingMenuItem( 
                  icon: Icons.delete, 
                  color: CupertinoColors.destructiveRed,
                  onTap: () {

                  }
                ),
                FloatingMenuItem( 
                  icon: Icons.star, 
                  onTap: () {

                  }
                )],
              FloatingMenuItem( 
                icon: Icons.swap_calls, 
                onTap: () {
                  setState(() {
                    _isByMonth.value = !_isByMonth.value;
                  });
                }
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
    return InkWell(
      onTap: onTap,
      child: const Padding(
        padding: EdgeInsets.all(16), 
        child: Center(child: Icon(Icons.add))
      )
    );
  }
}