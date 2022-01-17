import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showLoaderDialog(BuildContext context, [String message]) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
          child: Center(
            child: Container(
              color: Colors.white,
              child: Image.asset(
                'assets/images/loader.gif',
              ),
            ),
          ),
          onWillPop: () async => false);
    },
  );
}
