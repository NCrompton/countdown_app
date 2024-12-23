import 'package:calendar/components/budget_entry_cell.dart';
import 'package:calendar/components/floating_button.dart';
import 'package:calendar/model/budget_schema.dart';
import 'package:calendar/pages/add_budget_entry_page.dart';
import 'package:calendar/screens/budget_entry_page.dart';
import 'package:calendar/providers/budget_entry_provider.dart';
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
          ),
          FloatingMenu(
            menuItems: [
              FloatingMenuItem( 
                icon: Icons.delete, 
                color: CupertinoColors.destructiveRed,
                onTap: () {

                }
              ),
              FloatingMenuItem( 
                icon: Icons.star, 
                onTap: () {

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