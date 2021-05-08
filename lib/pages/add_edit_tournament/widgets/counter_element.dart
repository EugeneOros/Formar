import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:form_it/widgets/round_icon_button.dart';

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
          RoundIconButton(
            icon: Icons.remove,
            onPressed: () {},
          ),
          SizedBox(width: counter < 0 ? 10 : 12),
          Text(counter.toString(), style: Theme.of(context).textTheme.bodyText2),
          SizedBox(width: counter < 0 ? 10 : 12),
          RoundIconButton(
            icon: Icons.add,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
