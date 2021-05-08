import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';

class RoundIconButton extends StatelessWidget {
  final Function()? onPressed;
  final IconData icon;

  const RoundIconButton({Key? key, this.onPressed, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      onPressed: onPressed,
      style: NeumorphicStyle(
        depth: 1,
        surfaceIntensity: 0.4,
        color: Theme
            .of(context)
            .primaryColorLight,
        shape: NeumorphicShape.concave,
        boxShape: NeumorphicBoxShape.circle(),
      ),
      padding: const EdgeInsets.all(7.0),
      child: Icon(
        icon,
        size: 13,
      ),
    );

  }
}
