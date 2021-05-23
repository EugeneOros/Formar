import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';

import 'dependency.dart';

final GlobalKey<ScaffoldState> homeKey = GlobalKey<ScaffoldState>();

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffc0c0c0), width: 2.0)),
  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.pink, width: 2.0)),
);

const borderRoundedTransparent = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(15.0)),
  borderSide: BorderSide(
    color: Colors.transparent,
  ),
);

const borderSideDivider = BorderSide(color: Color(0xFFBDBDBD), width: 0.5);

BorderSide getBorderDivider(BuildContext context) {
  return BorderSide(color: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DividerDarkColor : Color(0xFFBDBDBD), width: 0.5);
}

BoxDecoration roundedShadowDecoration = BoxDecoration(
  boxShadow: [
    BoxShadow(
      color: Colors.white, //Colors.grey.withOpacity(0.2),
      spreadRadius: 5,
      blurRadius: 7,
      offset: Offset(2, 2),
    )
  ],
  borderRadius: BorderRadius.all(Radius.circular(30)),
);

Size textSize(String text, TextStyle? style) {
  final TextPainter textPainter = TextPainter(text: TextSpan(text: text, style: style), maxLines: 1, textDirection: TextDirection.ltr)
    ..layout(minWidth: 0, maxWidth: double.infinity);
  return textPainter.size;
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

PageRouteBuilder getPageRouteBuilder(
    {required Widget Function(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) pageBuilder}) {
  return PageRouteBuilder(
    pageBuilder: pageBuilder,
    transitionDuration: Duration(milliseconds: 500),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      animation = CurvedAnimation(curve: Curves.easeInOutSine, parent: animation);
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

NeumorphicStyle getInnerNeumorphicStyle({required BuildContext context, Color? color}) {
  return NeumorphicStyle(
      depth: -1.5,
      intensity: 1,
      shape: NeumorphicShape.concave,
      boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
      lightSource: LightSource.topLeft,
      shadowDarkColorEmboss: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorShadowDark : Colors.grey.withOpacity(0.7),
      shadowLightColorEmboss: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorShadowLight : Colors.white.withOpacity(0.7),
      color: color ?? Theme.of(context).canvasColor);
}
