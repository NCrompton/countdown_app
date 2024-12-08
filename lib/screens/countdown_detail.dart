import 'dart:async';

import 'package:calendar/providers/date_provider.dart';
import 'package:calendar/utils/date_util.dart';
import 'package:calendar/utils/view_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/countdown_data.dart';

class CountdownDateDetail extends ConsumerStatefulWidget {
  final CountdownData countdown;

  const CountdownDateDetail({
    super.key,
    required this.countdown,
  });

  @override
  ConsumerState<CountdownDateDetail> createState() => CountdownDateDetailState();

}
  class CountdownDateDetailState extends ConsumerState<CountdownDateDetail> {

    late Timer timer;
    Duration diff = const Duration();
    bool isbeforeNow = false;

    @override
    void initState() {
      super.initState();
      updateInterval();

      timer = Timer.periodic(const Duration(seconds: 10), (Timer t) => updateInterval());
    }

    void updateInterval() {
      setState(() {
        isbeforeNow = widget.countdown.date.isBefore(DateTime.now());
        diff = isbeforeNow ? DateTime.now().difference(widget.countdown.date) : widget.countdown.date.difference(DateTime.now()); 
      });
    }

    Future<bool> _deleteDate() async {
      final success = await ref.read(asyncDateStateProvider.notifier).removeDate(widget.countdown.id);
      return success;
    }

    @override
    dispose() {
      super.dispose();
      timer.cancel();
    }

  @override
  Widget build(BuildContext context) {

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.countdown.name),
      ),
      child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(isbeforeNow? "Since" : "To"),
                        Text(widget.countdown.date.formatToStandard()),
                        Text(
                          "${diff.inDays}d ${diff.inHours - diff.inDays*24}h ${diff.inMinutes - diff.inHours*60}m",
                          style: const TextStyle(fontSize: 32),
                        ),
                      ],
                    ), 
                  ),
                  Container(
                    width: double.infinity, 
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: CupertinoButton.filled(
                      alignment: Alignment.bottomCenter,
                      onPressed: () async {
                        onLoading(context);
                        final success = await _deleteDate();
                        if (mounted) {
                          finishLoading(context);
                          if (success) {
                            Navigator.pop(context);
                          } 
                        }
                      },
                      child: const Text("Delete"),
                  )),
                  const SizedBox(height: 10),
                ],
              ),
            )
      ),
    );
  }
}