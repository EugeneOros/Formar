import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:form_it/config/constants.dart';
import 'package:form_it/config/dependency.dart';

class ItemTournamentStatistic extends StatelessWidget {
  final String text;
  final bool drawDivider;
  final Widget? secondaryWidget;

  const ItemTournamentStatistic({Key? key, required this.text, this.drawDivider = false, this.secondaryWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 300,
      // constraints: BoxConstraints(maxHeight: 50),
      // padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: drawDivider ? BoxDecoration(border: Border(top: borderSideDivider)) : null,
      child: Row(
        children: [
          IntrinsicHeight(
            child: IntrinsicWidth(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  StatisticBox(value: 1, color: Theme.of(context).primaryColorLight,),
                  StatisticBox(value: 2, ),
                  StatisticBox(value: 1, color: Theme.of(context).primaryColorLight,),
                  StatisticBox(value: 3,),
                  StatisticBox(value: 1, color: Theme.of(context).primaryColorLight,),
                  StatisticBox(value: 2, ),
                  StatisticBox(value: 1, color: Theme.of(context).primaryColorLight,),
                  StatisticBox(value: 3,),
                  StatisticBox(value: 1, color: Theme.of(context).primaryColorLight,),
                  StatisticBox(value: 2, ),
                  StatisticBox(value: 1, color: Theme.of(context).primaryColorLight,),
                  // StatisticBox(value: 3,),
                ],
              ),
            ),
          ),
          if (secondaryWidget != null) secondaryWidget!,
        ],
      ),
    );
  }
}

class StatisticBox extends StatelessWidget {
  final int value;
  final Color color;

  const StatisticBox({Key? key, required this.value, this.color = Colors.white}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: 35,
      width: 40,
      color: color,
      child: Text(value.toString(), textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText2,),
    );
  }
}

