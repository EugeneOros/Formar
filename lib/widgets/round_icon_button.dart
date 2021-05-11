import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';

class RoundIconButton extends StatelessWidget {
  final Function()? onPressed;
  final IconData icon;
  final Color? color;
  final double size;

  const RoundIconButton({Key? key, this.onPressed, required this.icon, this.color, this.size = 24}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      onPressed: onPressed,
      style: NeumorphicStyle(
        depth: 1,
        surfaceIntensity: 0.4,
        color: color ?? Theme.of(context).primaryColorLight,
        shape: NeumorphicShape.concave,
        boxShape: NeumorphicBoxShape.circle(),
      ),
      padding: EdgeInsets.all(size/4),
      child: Icon(
        icon,
        size: size/2,
      ),
    );
  }
}
