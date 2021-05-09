import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';

class TournamentStatistic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Neumorphic(
        style: NeumorphicStyle(
          depth: 0,
          color: Theme.of(context).primaryColorLight,
          boxShape: NeumorphicBoxShape.rect(),
          shape: NeumorphicShape.convex,
          lightSource: LightSource.topRight,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomLeft,
              colors: [
                Theme.of(context).primaryColorLight,
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor,
                Theme.of(context).accentColor,
              ],
            ),
          ),
        ));
  }
}
