import 'package:flutter/material.dart';

final GlobalKey<ScaffoldState> homeKey = GlobalKey<ScaffoldState>();

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xffc0c0c0), width: 2.0)),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.pink, width: 2.0)),
);

const borderRoundedTransparent = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(30.0)),
  borderSide: BorderSide(
    color: Colors.transparent,
  ),
);

const borderSideDivider = BorderSide(color: Color(0xFFBDBDBD), width: 0.5);

BoxDecoration roundedShadowDecoration = BoxDecoration(
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withOpacity(0.2),
      spreadRadius: 5,
      blurRadius: 7,
      offset: Offset(2, 2),
    )
  ],
  borderRadius: BorderRadius.all(Radius.circular(30)),
);

Size textSize(String text, TextStyle? style) {
  final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style), maxLines: 1, textDirection: TextDirection.ltr)
    ..layout(minWidth: 0, maxWidth: double.infinity);
  return textPainter.size;
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
