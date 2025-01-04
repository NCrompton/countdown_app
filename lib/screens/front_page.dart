import 'package:calendar/providers/tab_provider.dart';
import 'package:calendar/screens/budget_thread_list.dart';
import 'package:calendar/screens/date_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef FrontPageNavigation = (String, IconData, Widget);

const navigationItems = <FrontPageNavigation>[
  // ("Home", CupertinoIcons.home, HomePage()),
  ("Countdown", CupertinoIcons.time, DateListPage()),
  ("Budget", CupertinoIcons.money_dollar_circle, BudgetThreadList()),
];

class FrontPage extends ConsumerWidget {
  const FrontPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CupertinoTabScaffold(
      resizeToAvoidBottomInset: false,
      tabBar: CupertinoTabBar(
        onTap: (i) => ref.read(tabProvider.notifier).state = i,
        items: navigationItems.map((e) => 
          BottomNavigationBarItem(
            icon: Icon(e.$2),
            label: e.$1,
          ),
        ).toList()
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView( // Use IndexStack for preload tab
          builder: (context) {
            return navigationItems[index].$3;
          } 
        );
      }
    );
  }
}