import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xffc0c0c0), width: 2.0)),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.pink, width: 2.0)),
);

const borderRoundedTransparent = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(90.0)),
  borderSide: BorderSide(
    color: Colors.transparent,
  ),
);