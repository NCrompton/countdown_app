import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void onLoading(BuildContext context) {
  showCupertinoDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
        ]
      );
    },
  );
}

void finishLoading(BuildContext context) {
  Navigator.pop(context);
}

void showCupertinoPickerPopup({
  required BuildContext context, 
  required Widget picker,
}) {
  showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          top: false,
          child: Container(
            height: 300,
            color: CupertinoColors.systemBackground,
            child: Column(
              children: [
                SizedBox(
                  height: 240,
                  child:  picker,
                ),
                CupertinoButton(
                  child: const Text('Done'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ]
            )
          ),
        );
      }
  );
}