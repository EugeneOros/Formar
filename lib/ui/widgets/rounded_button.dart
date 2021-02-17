import 'package:flutter/material.dart';
import 'package:form_it/ui/shared/colors.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color, textColor;
  final double sizeRatio;

  const RoundedButton({
    Key key,
    this.text,
    this.onPressed,
    this.color = Colors.black,
    this.textColor = Colors.white,
    this.sizeRatio = 0.8,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Container(
      width: size.width * sizeRatio,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(27.0),
        child: FlatButton(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          color: color,
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }
}
