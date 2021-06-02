import 'dependency.dart';

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

BorderSide getBorderDivider(BuildContext context) {
  return BorderSide(color: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DividerDarkColor : Color(0xFFBDBDBD), width: 0.5);
}