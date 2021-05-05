import 'package:flutter/material.dart';

class FadeEndLIstView extends StatelessWidget {
  final double height;
  final double width;
  final Color color;
  final bool isTop;

  const FadeEndLIstView({Key? key, this.height = 10, this.color = Colors.white, this.isTop = true, this.width = 10}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: isTop ? 0.0 : null,
      bottom: isTop ? null : 0.0,
      width: width,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: isTop ? Alignment.topCenter : Alignment.bottomCenter,
            end: isTop ? Alignment.bottomCenter : Alignment.topCenter,
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