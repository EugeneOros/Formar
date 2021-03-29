import 'package:flutter/material.dart';

class AppSnackBar extends SnackBar {
  final Color? actionColor;
  final Color? color;

  AppSnackBar(  {
    Key? key,
    required String text,
    required String actionName,
    required VoidCallback onAction,
    this.actionColor,
    this.color,
  }) : super(
          key: key,
          content: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          backgroundColor: color ?? Colors.black,
          duration: Duration(seconds: 3),
          action: SnackBarAction(
            label: actionName,
            textColor: actionColor ?? Colors.white,
            onPressed: onAction,
          ),
        );
}
