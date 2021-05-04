import 'package:flutter/material.dart';

class FadeEndLIstView extends StatelessWidget {
  final double height;
  final double width;
  final Color color;
  final bool fromTopToBottom;

  const FadeEndLIstView({Key? key, this.height = 10, this.color = Colors.white, this.fromTopToBottom = true, this.width = 10}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: fromTopToBottom ? 0.0 : null,
      bottom: fromTopToBottom ? null : 0.0,
      width: width,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: fromTopToBottom ? Alignment.topCenter : Alignment.bottomCenter,
            end: fromTopToBottom ? Alignment.bottomCenter : Alignment.topCenter,
            stops: [0.0, 1.0],
            colors: [
              color,
              color.withOpacity(0.0),
            ],
          ),
        ),
      ),
    );
  }
}