import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_it/ui/shared/colors.dart';

class Loading extends StatelessWidget {
  final Color backgroundColor;
  final Color indicatorColor;

  Loading({Key key, this.backgroundColor = Colors.white, this.indicatorColor = Colors.black} ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Center(
        child: SpinKitSquareCircle(
          color: indicatorColor,
          size: 50.0,
        ),
      ),
    );
  }
}
