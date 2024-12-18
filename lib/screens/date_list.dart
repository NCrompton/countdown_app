import 'package:calendar/components/date_list_cell.dart';
import 'package:calendar/controllers/date_controller.dart';
import 'package:calendar/controllers/view_provider.dart';
import 'package:calendar/layout/floating_bottom_drawer.dart';
import 'package:calendar/providers/date_provider.dart';
import 'package:calendar/pages/add_date.dart';
import 'package:calendar/utils/route_transition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calendar/screens/countdown_detail.dart';
import 'package:home_widget/home_widget.dart';

final provider= asyncDateStateProvider;

class DateListPage extends ConsumerStatefulWidget {
  const DateListPage({super.key});
  @override
  ConsumerState<DateListPage> createState() => _DateListPageState();
}

class _DateListPageState extends ConsumerState<DateListPage> with SingleTickerProviderStateMixin {
  bool _isPanelVisible = false;

  final _dateController = DateCalculatorController(DateTime.now(), 0);
  final _visibilityController = VisibilityController(false);
  double panelHeight = 0;

  @override
  void initState() {
    super.initState();

    HomeWidget.getInstalledWidgets().then((v) {
      print("list of widget: $v");
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _togglePanel() {
    setState(() {
      _isPanelVisible = !_isPanelVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateState = ref.watch(asyncDateStateProvider);
    final size = MediaQuery.of(context).size;
    panelHeight = size.height * 0.8; // 80% of screen he

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

  Widget _buildBody(AsyncValue<DateState> dateState) {
    final dates = dateState.value?.dateList;
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
                    onRefresh: () async {
                    },
                  ),
                  SliverToBoxAdapter(
                    child: (dates == null || dates.isEmpty) 
                      ? const SizedBox() 
                      : CupertinoListSection(
                          children: dates.map((countdownData) {
                            return Builder(
                              builder: (context) {
                                return DateListCell(
                                  onTap: () {
                                    openPageSide(context, CountdownDateDetail(countdown: countdownData));
                                  },
                                  data: countdownData, 
                                  isTarget: (countdownData.id == targetDateId),
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
              child: AddDatePage(dismiss: () => _visibilityController.setVisibility(false)), 
            ),
          ],
        ),
      );
  }
}
