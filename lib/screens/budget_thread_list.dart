import 'package:calendar/components/list_cell.dart';
import 'package:calendar/layout/swipeable_tab_view.dart';
import 'package:calendar/layout/floating_bottom_drawer.dart';
import 'package:calendar/model/budget_schema.dart';
import 'package:calendar/pages/add_budget_thread_page.dart';
import 'package:calendar/pages/budget_thread_page.dart';
import 'package:calendar/providers/budget_thread_provider.dart';
import 'package:calendar/utils/date_util.dart';
import 'package:calendar/utils/helper.dart';
import 'package:calendar/utils/route_transition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetThreadList extends ConsumerWidget {
  const BudgetThreadList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final threadsProvider = ref.watch(budgetThreadProviderProvider);

    return FloatingBottomDrawerScaffold(
      title: "Budget Threads",
      heightPortion: 0.5,
      drawerChild: (dismiss) => AddBudgetThreadPage(dismiss: dismiss),
      builder: (context, visibilityController) {
        return CustomScrollView(
                slivers: [
                  CupertinoSliverRefreshControl(
                    onRefresh: () async {
                    },
                  ),
                  SliverToBoxAdapter(
                    child: CustomListCell(
                      leftWidget: const Text("All Entries"), 
                      onTap: () => openPageSide(
                        context,
                        Container(),
                      )
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: switch(threadsProvider) {
                      AsyncData(:final value) => value.isEmpty? 
                        const SizedBox(child: Text("nothing")) : 
                        CupertinoListSection(
                          children: value.mapIndexed((thread, i) {
                            return Builder(
                              builder: (context) {
                                return BudgetThreadCell(
                                  onTap: () =>
                                    openPageSide(
                                      context, 
                                      SwipeableTabView(
                                        pages: value.map((e) => BudgetThreadPage(thread: e)).toList(),
                                        tabNames: value.map((e) => e.threadName).toList(),
                                        initialPage: i,
                                      ),
                                    ),
                                  thread: thread,
                                );
                              },
                            );
                          }).toList(),
                        ),
                      AsyncError(:final error) => Text("Error: $error"),
                      _ => const Center(child: CircularProgressIndicator()), 
                    }
                  ),
                ],
              );
      }
    );
  }
}

class BudgetThreadCell extends StatelessWidget {
  final BudgetThread thread;
  final GestureTapCallback? onTap;

  const BudgetThreadCell({super.key, required this.thread, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListCell(
      onTap: onTap,
      leftWidget: Text(thread.threadName), 
      subLeftWidget: Text( "${thread.budgets.firstOrNull?.entryTime.formatToShortDisplay()} - ${thread.budgets.lastOrNull?.entryTime.formatToShortDisplay()}"),
    );
  }
}