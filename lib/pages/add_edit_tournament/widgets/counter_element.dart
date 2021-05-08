import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';

class CounterElement extends StatelessWidget {
  final int counter;

  const CounterElement({Key? key, required this.counter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          NeumorphicButton(
            onPressed: () {},
            style: NeumorphicStyle(
              depth: 1,
              surfaceIntensity: 0.4,
              color: Theme.of(context).primaryColorLight,
              shape: NeumorphicShape.concave,
              boxShape: NeumorphicBoxShape.circle(),
            ),
            padding: const EdgeInsets.all(7.0),
            child: Icon(
              Icons.add,
              size: 13,
            ),
          ),
          SizedBox(width: counter < 0 ? 10 : 12),
          Text(
            counter.toString(),
            style: Theme.of(context).textTheme.bodyText2,
          ),
          SizedBox(width: counter < 0 ? 10 : 12),
          NeumorphicButton(
            onPressed: () {},
            style: NeumorphicStyle(
              depth: 1,
              surfaceIntensity: 0.4,
              color: Theme.of(context).primaryColorLight,
              shape: NeumorphicShape.concave,
              boxShape: NeumorphicBoxShape.circle(),
            ),
            padding: const EdgeInsets.all(7.0),
            child: Icon(
              Icons.remove,
              size: 13,
            ),
          ),
        ],
      ),
    );
  }
}
