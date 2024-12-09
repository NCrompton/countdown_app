import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SwipeableTabView extends StatefulWidget {
  final List<Widget> pages;
  final int initialPage;
  final List<String> tabNames;

  const SwipeableTabView({
    super.key,
    required this.pages,
    required this.tabNames,
    int? initialPage,
  }):initialPage = initialPage ?? 0;

  @override
  State<SwipeableTabView> createState() => _SwipeableTabViewState();
}

class _SwipeableTabViewState extends State<SwipeableTabView> with TickerProviderStateMixin{
  late PageController _pageController;
  late TabController _tabController;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.pages.length, vsync: this);
    _tabController.index = widget.initialPage;
    _currentPage = _tabController.index;
    _tabController.addListener((){
        setState(() {
          _currentPage = _tabController.index;
        });
      }
    );
  }

  void _updateCurrentPage(int index) {
    _tabController.index = index;
    setState(() {
      _currentPage = index;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Budgets'),
      ),
      child: SafeArea(
        child: Material(
          child: _buildPageView()
        ),
      )
    );
  }

  Widget _buildPageView() {
    return Column(
      children: [
        PageIndicator(
          tabController: _tabController, 
          currentPageIndex: _currentPage, 
          onUpdateCurrentPageIndex: _updateCurrentPage,
          tabNames: widget.tabNames,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget.pages,
          )
        ),
      ],
    );
  }
} 

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.tabController,
    required this.currentPageIndex,
    required this.onUpdateCurrentPageIndex,
    required this.tabNames,
  });

  final int currentPageIndex;
  final TabController tabController;
  final void Function(int) onUpdateCurrentPageIndex;
  final List<String> tabNames;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: 
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            splashRadius: 16.0,
            padding: EdgeInsets.zero,
            onPressed: () {
              if (currentPageIndex == 0) {
                return;
              }
              onUpdateCurrentPageIndex(currentPageIndex - 1);
            },
            icon: Icon(
              Icons.arrow_left_rounded,
              size: 32.0,
              color: (currentPageIndex > 0) ? CupertinoColors.activeBlue : CupertinoColors.inactiveGray,
            ),
          ),
          SizedBox(
            height: 24,
            width: MediaQuery.of(context).size.width - 128,
            child: TabBarView(
              controller: tabController,
              children: tabNames.map((e) => Center(child: Text(e, style: const TextStyle(fontSize: 18),))).toList(),
            )
          ),
          IconButton(
            splashRadius: 16.0,
            padding: EdgeInsets.zero,
            onPressed: () {
              if (currentPageIndex == tabNames.length - 1) {
                return;
              }
              onUpdateCurrentPageIndex(currentPageIndex + 1);
            },
            icon: Icon(
              Icons.arrow_right_rounded,
              size: 32.0,
              color: (currentPageIndex < tabNames.length - 1) ? CupertinoColors.activeBlue : CupertinoColors.inactiveGray,
            ),
          ),
        ],
      ),
    );
  }
}