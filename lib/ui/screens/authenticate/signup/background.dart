import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.maybeOf(context).size;
    return Container(
      height: size.height,
      width: size.width,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
              top: 0,
              left: 0,
              child: SvgPicture.asset(
                "assets/shape_signup_top.svg",
                width: size.width * 0.25,
              )),
          Positioned(
              top: size.height / 2,
              right: 0,
              child: SvgPicture.asset(
                "assets/shape_signup_center.svg",
                width: size.width * 0.25,
              )),
          Positioned(
              bottom: 0,
              left: 0,
              child: SvgPicture.asset(
                "assets/shape_signup_bottom.svg",
                width: size.width * 0.2,
              )),
          child,
        ],
      ),
    );
  }
}
