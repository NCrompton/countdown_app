import 'dart:async';

import 'package:calendar/components/date_list_cell.dart';
import 'package:calendar/controllers/date_controller.dart';
import 'package:calendar/controllers/view_provider.dart';
import 'package:calendar/layout/floating_bottom_drawer.dart';
import 'package:calendar/providers/date_provider.dart';
import 'package:calendar/pages/add_date.dart';
import 'package:calendar/providers/tab_provider.dart';
import 'package:calendar/screens/date_calculation_page.dart';
import 'package:calendar/utils/route_transition.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calendar/screens/countdown_detail.dart';

final provider= asyncDateStateProvider;

class DateListPage extends ConsumerStatefulWidget {
  const DateListPage({super.key});
  @override
  ConsumerState<DateListPage> createState() => _DateListPageState();
}

class _DateListPageState extends ConsumerState<DateListPage> with SingleTickerProviderStateMixin {
  final _dateController = DateCalculatorController(DateTime.now(), 0);
  final _visibilityController = VisibilityController(false);
  Timer? _timer;
  final ValueNotifier<Duration> _elapseController = ValueNotifier(Duration.zero);
  late final DateTime origin;

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override 
  void initState() {
    super.initState();
    origin = DateTime.now();
    _initTime();
  }

  void _initTime() {
    if (_timer?.isActive == true) return; 
    _timer = Timer.periodic(
      const Duration(seconds: 1), 
      (_) {
        _elapseController.value = origin.difference(DateTime.now());
      }
    );
  }

  void _showDateSelection(BuildContext context) async {
    final _ = await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => const DateCalculationPage(),
      ),
    );
  }

  void _deleteCell(String id) =>
    ref.read(asyncDateStateProvider.notifier).removeDate(id);

  void _setAsTargetDate(String id) =>
    ref.read(asyncDateStateProvider.notifier).setTargetDate(id);

  Widget _buildBody(AsyncValue<DateState> dateState) {
    final targetDateId = dateState.value?.targetDate?.id;

    return SafeArea(
        child: Stack(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => _visibilityController.setVisibility(false),
              child: CustomScrollView(
                slivers: [
                  CupertinoSliverRefreshControl(
                    onRefresh: () =>
                      ref.refresh(asyncDateStateProvider.future)
                  ),
                  SliverToBoxAdapter(
                    child: switch(dateState) {
                      AsyncData(:final value) => 
                      (value.dateList.isEmpty) 
                        ? const SizedBox() 
                        : CupertinoListSection(
                            children: value.dateList.mapIndexed((index, countdownData) {
                              return DateCell(
                                data: countdownData,
                                onStar: () => _setAsTargetDate(countdownData.id), 
                                onDelete: () => _deleteCell(countdownData.id), 
                                onTap: () => openPageSide(context, CountdownDateDetail(countdown: countdownData)),
                                elapseController: _elapseController,
                                isTarget: countdownData.id == targetDateId, 
                              ); 
                            }).toList(),
                          ),
                    _ => const CircularProgressIndicator(),
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              right: 16,
              bottom: 16,
              child: GestureDetector(
                onTap: () => _showDateSelection(context),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: CupertinoColors.activeBlue,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    CupertinoIcons.calendar_badge_plus,
                    color: CupertinoColors.white,
                  ),
                ),
              ),
            ),
            FloatingBottomDrawer(
              visibilityController: _visibilityController,
              heightPortion: 0.5,
              child: AddDatePage(dismiss: () => _visibilityController.setVisibility(false)), 
            ),
          ],
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final dateState = ref.watch(asyncDateStateProvider);
    ref.listen<int>(tabProvider, (_, n) {
      if (n != 0) return _timer?.cancel();
      _initTime();
    });

    return  ListenableBuilder(listenable: _dateController, builder: (BuildContext context, Widget? child){ 
              return ListenableBuilder(listenable: _visibilityController, builder: (BuildContext context, Widget? child){ 
                return GestureDetector(
                  onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                  child: CupertinoPageScaffold(
                    resizeToAvoidBottomInset: false,
                    navigationBar: CupertinoNavigationBar(
                      middle: const Text('Target Date List'),
                      trailing: IconButton(
                        onPressed: _visibilityController.toggleVisibility, 
                        icon: Icon(_visibilityController.visible ? Icons.close : Icons.add)
                      ),
                    ),
                    child: _buildBody(dateState),
                  )
                );
              });
            }); 
  }
}
