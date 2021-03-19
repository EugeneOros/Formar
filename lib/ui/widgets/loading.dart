import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  final Color backgroundColor;
  final Color indicatorColor;
  final BoxDecoration decoration;

  Loading({Key key, this.backgroundColor = Colors.white, this.indicatorColor = Colors.black, this.decoration} ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration,
      color: decoration == null ? backgroundColor : null,
      child: Center(
        child: SpinKitSquareCircle(
          color: indicatorColor,
          size: 50.0,
        ),
      ),
    );
  }
}
