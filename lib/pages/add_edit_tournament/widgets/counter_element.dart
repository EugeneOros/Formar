import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:form_it/widgets/round_icon_button.dart';

class CounterElement extends StatelessWidget {
  final int counter;
  final ValueChanged<int> onChange;
  final bool isPositive;

  const CounterElement({Key? key, required this.counter, required this.onChange, this.isPositive=false}) : super(key: key);

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
            onPressed: () {
              if (counter - 1 > (isPositive ? 0 : -10)) {
                onChange(counter - 1);
              }
            },
          ),
          SizedBox(width: counter < 0 ? 10 : 12),
          Text(counter.toString(), style: Theme.of(context).textTheme.bodyText2),
          SizedBox(width: counter < 0 ? 10 : 12),
          RoundIconButton(
            icon: Icons.add,
            onPressed: () {
              if (counter + 1 < 10) {
                onChange(counter + 1);
              }
            },
          ),
        ],
      ),
    );
  }
}
