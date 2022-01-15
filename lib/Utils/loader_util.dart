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
            //  backgroundColor: Colors.transparent,
             /* height: MediaQuery.of(context).size.height*0.99,
              width: MediaQuery.of(context).size.width*0.99,*/
              color: Colors.white,
              child: Image.asset(
                'assets/images/loader.gif',
              ),
            ),
          ),onWillPop: () async => false
        );
      },
    );
  }
 /* getToast({String message, Color color}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      fontSize: 14,
      textColor: Colors.white,
      backgroundColor: color,
    );
  }*/


