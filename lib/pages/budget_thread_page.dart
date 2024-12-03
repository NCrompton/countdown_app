import 'package:calendar/components/list_cell.dart';
import 'package:calendar/layout/floating_bottom_drawer.dart';
import 'package:calendar/model/budget_model.dart';
import 'package:calendar/pages/add_budget_entry_page.dart';
import 'package:calendar/utils/const.dart';
import 'package:calendar/utils/date_util.dart';
import 'package:calendar/utils/route_transition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BudgetThreadPage extends StatefulWidget {
  final BudgetThread thread;
  const BudgetThreadPage({super.key, required this.thread});

  @override
  State<BudgetThreadPage> createState() => _BudgetThreadPageState();
}

class _BudgetThreadPageState extends State<BudgetThreadPage> {

  // final visibilityController = VisibilityController(false);
  
  @override
  Widget build(BuildContext context) {
    final budgets = widget.thread.budgets;
    return FloatingBottomDrawerPage(
      heightPortion: 0.7,
      drawerChild: const AddBudgetEntryPage(),
      build: (context, visibilityController) {
        return CustomScrollView(
                    slivers: [
                      CupertinoSliverRefreshControl(
                        onRefresh: () async {
                        },
                      ),
                      SliverToBoxAdapter(
                        child: (budgets.isEmpty) 
                          ? const SizedBox() 
                          : CupertinoListSection(
                              children: [...budgets.map((entry) {
                                  return Builder(
                                    builder: (context) {
                                      return BudgetEntryCell(
                                        onTap: () {
                                          openPageSide(
                                            context, 
                                            Container(),
                                          );
                                        },
                                        entry: entry,
                                      );
                                    },
                                  );
                                }).toList(),
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
      leftWidget: _leftWidget(),
      rightWidget: Text("${entry.price.currency.name.toUpperCase()} ${entry.price.value}", 
        style: TextStyle(color: entry.price.value < 0 ? const Color(negativeColor) : const Color(positiveColor))
      ),
      onTap: onTap,
    );
  }

  Widget _leftWidget() {
    return Row(
        children:[
          CircleAvatar(
            backgroundColor: entry.entryType.color,
            foregroundColor: entry.entryType.color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
            child: Icon(entry.entryType.icon),
          ),
          const SizedBox(width: 8),
          CellTitle(primaryTitle: entry.entryName, secondaryTitle: entry.entryTime.formatToDisplay(),)
        ],
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