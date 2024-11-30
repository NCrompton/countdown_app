import 'package:calendar/screens/date_calculation_page.dart';
import 'package:calendar/pages/front_page.dart';
import 'package:flutter/cupertino.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title});
  final String title;

  void _showDateSelection(BuildContext context) async {
    final _ = await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => const DateCalculationPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(title),
      ),
      child: Stack(
        children: [
          // Add safe area to prevent content from going under the navigation bar
          const SafeArea(
            child: DatePage(),
          ),
          // Position the button at the bottom right
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
        ],
      ),
    );
  }
}