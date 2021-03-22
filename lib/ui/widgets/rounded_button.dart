import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;
  final Color color, textColor;
  final double sizeRatio;
  final double marginHorizontal;
  final double marginVertical;

  const RoundedButton({
    Key? key,
    this.text,
    this.onPressed,
    this.color = Colors.black,
    this.textColor = Colors.white,
    this.sizeRatio = 0.8,
    this.marginHorizontal = 0.0,
    this.marginVertical = 0.0
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Container(
      margin: EdgeInsets.symmetric( horizontal: marginHorizontal, vertical: marginVertical),
      width: sizeRatio != null ? size.width * sizeRatio : null,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50.0),
        child: FlatButton(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          color: color,
          onPressed: onPressed,
          child: Text(
            text!,
            style: TextStyle(color: textColor),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
