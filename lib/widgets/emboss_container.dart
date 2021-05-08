import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';

class EmbossContainer extends StatelessWidget {
  final Widget? child;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final String? name;

  const EmbossContainer({Key? key, this.child, this.margin, this.padding, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        name != null
            ? Padding(
                padding: EdgeInsets.only(bottom: 5, top: 25, left: 10),
                child: Text(
                  name!,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              )
            : SizedBox(),
        Container(
            margin: margin,
            padding: padding,
            child: Neumorphic(
              style: NeumorphicStyle(
                  depth: -1.5,
                  intensity: 1,
                  shape: NeumorphicShape.concave,
                  boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
                  lightSource: LightSource.topLeft,
                  color: Colors.white),
              child: child,
            )),
      ],
    );
  }
}
