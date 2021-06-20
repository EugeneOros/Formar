import 'package:form_it/config/dependency.dart';

class RoundedButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;
  final Color color, textColor;
  final double sizeRatio;
  final double marginHorizontal;
  final double marginVertical;
  final double? radius;

  const RoundedButton(
      {Key? key,
      this.text,
      this.onPressed,
      this.radius,
      this.color = Colors.black,
      this.textColor = Colors.white,
      this.sizeRatio = 0.8,
      this.marginHorizontal = 0.0,
      this.marginVertical = 0.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * sizeRatio,
      margin: EdgeInsets.symmetric(horizontal: marginHorizontal, vertical: marginVertical),
      // height: 50,
      child: NeumorphicButton(
        onPressed: onPressed,
        style: //getInnerNeumorphicStyle(context: context),
            NeumorphicStyle(
          depth: 1,
          intensity: 1,
          surfaceIntensity: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? 0 : 0.3,
          color: color,
          shape: NeumorphicShape.convex,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(radius ?? 15.0)),
          shadowDarkColor: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorShadowDark : Colors.grey.withOpacity(0.7),
          shadowLightColor: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorShadowLight : Colors.white.withOpacity(0.7),
          // color: color ?? (Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorAccent : Colors.white)
        ),
        padding: EdgeInsets.symmetric(vertical: 17, horizontal: 40),
        child: Text(
          text!, // "unknown",
          style: TextStyle(color: textColor),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ),
    );
    //   Container(
    //   decoration: roundedShadowDecoration,
    //   margin: EdgeInsets.symmetric(horizontal: marginHorizontal, vertical: marginVertical),
    //   width: size.width * sizeRatio,
    //   child: ClipRRect(
    //     borderRadius: BorderRadius.circular(radius ?? 15.0),
    //     child: TextButton(
    //       style: ButtonStyle(
    //         backgroundColor: MaterialStateProperty.all(color),
    //         padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 20, horizontal: 40)),
    //       ),
    //       onPressed: onPressed,
    //       child: Text(
    //         text!,
    //         style: TextStyle(color: textColor),
    //         textAlign: TextAlign.center,
    //       ),
    //     ),
    //   ),
    // );
  }
}
