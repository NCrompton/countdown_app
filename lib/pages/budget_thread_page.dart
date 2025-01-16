import 'package:calendar/components/budget_entry_cell.dart';
import 'package:calendar/components/floating_menu.dart';
import 'package:calendar/model/budget_schema.dart';
import 'package:calendar/pages/add_budget_entry_page.dart';
import 'package:calendar/providers/budget_thread_provider.dart';
import 'package:calendar/screens/budget_entry_page.dart';
import 'package:calendar/providers/budget_entry_provider.dart';
import 'package:calendar/utils/date_util.dart';
import 'package:calendar/utils/route_transition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

typedef ThreadDisplayStruct = Map<String, List<BudgetEntry>>;

class BudgetThreadPage extends ConsumerStatefulWidget {
  final BudgetThread? thread;
  const BudgetThreadPage({super.key, this.thread});
  int get notifierId => thread?.id ?? BudgetThread.allEntryId;
  String? get periodString => (thread?.endDate == null && thread?.beginDate == null)
    ? "Not yet begin"
    : "${thread?.beginDate?.formatToShortDisplay()} - ${thread?.endDate?.formatToShortDisplay()}";

  @override
  ConsumerState<BudgetThreadPage> createState() => _BudgetThreadPageState();
}

class _BudgetThreadPageState extends ConsumerState<BudgetThreadPage> {
  final ValueNotifier<bool> _isByMonth = ValueNotifier(true);
  DateFormat get formatter => _isByMonth.value ? DateFormat("MMM y") : DateFormat("dd MMM y");
  final ScrollController _scrollController = ScrollController();
  bool finishedPagination = false;
  double totalPrice = 0;
  int page = 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        _paginateEntries();
      }
    });
  }

  Future<void> _paginateEntries() async {
    if (!finishedPagination) page++;
    final f = 
      (await ref.read(budgetEntriesProviderProvider(widget.notifierId).notifier)
      .paginateEntries());
    setState(() => finishedPagination = f);
  }

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

  (List<List<BudgetEntry>>, List<String>) _renderDisplayStruct(List<BudgetEntry> entries) {
    List<List<BudgetEntry>> sliverList = [];
    List<String> date = [];
    int target = (page * 10 > entries.length) 
      ? entries.length
      : page * 10 - 1;
    for (final e in entries.sublist(0, target)) {
      final displayString = formatter.format(e.entryTime);
      if (displayString == date.lastOrNull) {
        sliverList.last.add(e);
      } else {
        date.add(displayString);
        sliverList.add([e]);
      }
    }
    return (sliverList, date);
  }

  Widget _buildEntryList(List<BudgetEntry> entries) {
    final (sliverList, date) = _renderDisplayStruct(entries);
    return ValueListenableBuilder<bool>(
      valueListenable: _isByMonth,
      builder: (context, isByMonth, child) {
        return CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: () async {
                // ignore: unused_result
                ref.refresh(budgetEntriesProviderProvider(widget.notifierId).future);
                finishedPagination = false;
                page = 1;
              }
            ),
            if (widget.thread != null) 
              SliverPersistentHeader(
                delegate: MyHeaderDelegate(
                  totalPrice: "HKD ${widget.thread?.totalPrice?.toStringAsFixed(2)}",
                  periodString: "${widget.periodString}",
                )
              ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: BudgetEntryAddCell(onTap: _showAddEntryPopup),
              )
            ),
            ...List.generate(
              sliverList.length,
              (i1) {
                return SliverMainAxisGroup(
                  slivers: [
                    SliverAppBar(
                      title: Text(date[i1], textAlign: TextAlign.start),
                      titleTextStyle: const TextStyle(fontSize: 16, color: Colors.black),
                      leading: const SizedBox.shrink(),
                      leadingWidth: 0,
                      forceElevated: true,
                      backgroundColor: CupertinoColors.systemBackground,
                      pinned: true,
                      toolbarHeight: 30,
                    ),
                    SliverList.builder(
                      itemCount: sliverList[i1].length,
                      itemBuilder: (context, i2) {
                        return BudgetEntryCell(
                            onTap: () {
                              openPageSide(
                                context, 
                                BudgetEntryPage(entry: sliverList[i1][i2]),
                              );
                            },
                            entry: sliverList[i1][i2],
                          );
                        },
                      )
                    ]
                );
              }
            ),
            if (finishedPagination) const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: Text("End", style: TextStyle(fontSize: 16, color: Colors.black54),))
              )
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(budgetEntriesProviderProvider(widget.notifierId));
    final targetThread = ref.watch(targetThreadProvider);
    return SafeArea(
      child: Stack(
        children: [
          switch(state) {
            AsyncData(:final value) => _buildEntryList(value),
            AsyncLoading() => const Center(child: CircularProgressIndicator()),
            AsyncError(:final error) => Text(error.toString()),
            _ => const SizedBox.shrink(),
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

class MyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String totalPrice;
  final String periodString;

  MyHeaderDelegate({
    required this.totalPrice,
    required this.periodString,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      clipBehavior: Clip.hardEdge,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: maxExtent,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Colors.white,
            Colors.blue,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(totalPrice, 
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 28,
            ),
          ),
          SizedBox(height: 8 * (128 - shrinkOffset) / 80),
          Text(periodString, style: const TextStyle(color: Colors.black54),),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 128;

  @override
  double get minExtent => 64;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}