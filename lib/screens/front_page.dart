import 'package:calendar/screens/budget_thread_list.dart';
import 'package:calendar/screens/date_list.dart';
import 'package:flutter/cupertino.dart';

typedef FrontPageNavigation = (String, IconData, Widget);

const navigationItems = <FrontPageNavigation>[
  // ("Home", CupertinoIcons.home, HomePage()),
  ("Countdown", CupertinoIcons.time, DateListPage()),
  ("Budget", CupertinoIcons.money_dollar_circle, BudgetThreadList()),
];

class FrontPage extends StatelessWidget {
  const FrontPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      resizeToAvoidBottomInset: false,
      tabBar: CupertinoTabBar(
        items: navigationItems.map((e) => 
          BottomNavigationBarItem(
            icon: Icon(e.$2),
            label: e.$1,
          ),
        ).toList()
      ),
      tabBuilder: (context, index) {
        return SafeArea(
          child: IndexedStack( // allow preload all pages
            index: index,
            children: navigationItems.map((e) => e.$3).toList(),
          )
        );
      }
    );
  }
}