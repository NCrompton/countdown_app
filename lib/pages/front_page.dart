import 'package:calendar/components/time_format_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calendar/components/front_page_info.dart';

class DatePage extends ConsumerWidget {
  const DatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: () async {
            // Handle refresh
          },
        ),
        const SliverFillRemaining(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: FrontPageInfo()),
              Center(child: TimeFormatPicker()),
            ],
          ),
        ),
      ],
    );
  }
}
