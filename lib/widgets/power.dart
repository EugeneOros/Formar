import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Power extends StatelessWidget {
  final int power;

  const Power({Key? key, required this.power}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Container(
          width: 20,
          height: 20,
          child: SvgPicture.asset("assets/power.svg"),
        ),
        Text(
          power.toString(),
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ],
    );
  }
}
