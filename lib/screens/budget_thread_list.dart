import 'package:calendar/components/list_cell.dart';
import 'package:calendar/dummy/dummy_data.dart';
import 'package:calendar/layout/swipeable_tab_view.dart';
import 'package:calendar/controllers/view_provider.dart';
import 'package:calendar/layout/floating_bottom_drawer.dart';
import 'package:calendar/model/budget_model.dart';
import 'package:calendar/pages/add_budget_thread_page.dart';
import 'package:calendar/pages/budget_thread_page.dart';
import 'package:calendar/utils/date_util.dart';
import 'package:calendar/utils/helper.dart';
import 'package:calendar/utils/route_transition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BudgetThreadList extends StatefulWidget {
  const BudgetThreadList({super.key});

  @override
  State<BudgetThreadList> createState() => _BudgetThreadListState();
}

class _BudgetThreadListState extends State<BudgetThreadList> {

  final _visibilityController = VisibilityController(false);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
                  onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                  child: CupertinoPageScaffold(
                    resizeToAvoidBottomInset: false,
                    navigationBar: CupertinoNavigationBar(
                      middle: const Text('Budget Threads'),
                      trailing: IconButton(
                        onPressed: _visibilityController.toggleVisibility, 
                        icon: Icon(_visibilityController.visible ? Icons.close : Icons.add)
                      ),
                    ),
                    child: _buildBody(context),
                  )
                );
  }

  final List<BudgetThread> tmp = dummyBudgetThread;

  _buildBody(BuildContext context) {
    return SafeArea(
        child: Stack(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => _visibilityController.setVisibility(false),
              child: CustomScrollView(
                slivers: [
                  CupertinoSliverRefreshControl(
                    onRefresh: () async {
                    },
                  ),
                  SliverToBoxAdapter(
                    child: (tmp == null || tmp.isEmpty) 
                      ? const SizedBox() 
                      : CupertinoListSection(
                          children: tmp.mapIndexed((thread, i) {
                            return Builder(
                              builder: (context) {
                                return BudgetThreadCell(
                                  onTap: () {
                                    openPageSide(
                                      context, 
                                      SwipeableTabView(
                                        pages: tmp.map((e) => BudgetThreadPage(thread: e)).toList(),
                                        tabNames: tmp.map((e) => e.threadName).toList(),
                                        initialPage: i,
                                      ),
                                    );
                                  },
                                  thread: thread,
                                );
                              },
                            );
                          }).toList(),
                        ),
                  ),
                ],
              ),
            ),
            FloatingBottomDrawer(
              visibilityController: _visibilityController,
              child: AddBudgetThreadPage(dismiss: () => _visibilityController.setVisibility(false)), 
            ),
          ],
        )
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
      leftWidget: CellTitle(primaryTitle: thread.threadName, 
        secondaryTitle: "${thread.budgets.first.entryTime.formatToShortDisplay()} - ${thread.budgets.last.entryTime.formatToShortDisplay()}",)
    );
  }
}