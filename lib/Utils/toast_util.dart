import 'package:flutter/material.dart';
import 'package:flutter_flexible_toast/flutter_flexible_toast.dart';

getToast({String message, Color color}) {
  FlutterFlexibleToast.showToast(
      message: message,
      toastLength: Toast.LENGTH_LONG,
      toastGravity: ToastGravity.BOTTOM,
      icon: color == Color(0xffF40909) ? ICON.ERROR : ICON.SUCCESS,
      elevation: 10,
      imageSize: 20,
      fontSize: 14,
      textColor: Colors.white,
      backgroundColor: color,
      timeInSeconds: 2);
}
