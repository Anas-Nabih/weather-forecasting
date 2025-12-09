import 'package:flutter/material.dart';
import 'package:forecast_weather/core/theme/colors.dart';
import 'package:nb_utils/nb_utils.dart';

Future<void> showToast({
  required String message,
  Duration? duration,
  Color? bgColor,
}) async {
  await Fluttertoast.cancel();
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.TOP,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

Future<void> showSuccess({required String message, Color? bgColor}) async {
  await Fluttertoast.cancel();
  await Fluttertoast.showToast(
    msg: message,
    backgroundColor: bgColor ?? AppColors.primaryLight,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.TOP,
  );
}
