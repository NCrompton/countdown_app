import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void onLoading(BuildContext context) {
  showCupertinoDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Row(
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
