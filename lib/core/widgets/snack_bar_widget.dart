import 'package:ava_hesab/config/app_colors.dart';
import 'package:flutter/material.dart';

void snackBarWithoutButton(BuildContext context, String title,
    {TextDirection textDirection = TextDirection.rtl, Duration duration = const Duration(seconds: 1)}) {
  var snackBar = SnackBar(
      content: Text(
        title,
        textDirection: textDirection,
        textAlign: TextAlign.right,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      margin: const EdgeInsets.all(16),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      duration: duration);
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void snackBarWithButton(BuildContext context, String title, String buttonText, Function() onPressed) {
  var snackBar = SnackBar(
    content: Text(
      title,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
    ),
    backgroundColor: Colors.black,
    margin: const EdgeInsets.all(16),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    action: SnackBarAction(
      label: buttonText,
      onPressed: onPressed,
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
