import 'package:form_it/config/dependency.dart';

class RoundIconButton extends StatelessWidget {
  final Function()? onPressed;
  final IconData icon;
  final Color? color;
  final Color? iconColor;
  final double size;

  const RoundIconButton({Key? key, this.onPressed, required this.icon, this.color, this.size = 24, this.iconColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      onPressed: onPressed,
      style: NeumorphicStyle(
        depth: 1,
        surfaceIntensity: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? 0 : 0.4,
        shadowDarkColor: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorShadowDark : Colors.grey.withOpacity(0.7),
        shadowLightColor:
            Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorShadowLight : Colors.white.withOpacity(0.7),
        color: color ?? (Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColor : Theme.of(context).primaryColorLight),
        shape: NeumorphicShape.concave,
        boxShape: NeumorphicBoxShape.circle(),
      ),
      padding: EdgeInsets.all(size / 4),
      child: Icon(
        icon,
        color: iconColor ?? (Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? LightPink : Colors.black),
        size: size / 2,
      ),
    );
  }
}
