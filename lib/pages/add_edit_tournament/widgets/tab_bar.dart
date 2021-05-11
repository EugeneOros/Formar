import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_it/config/dependency.dart';

import 'item_tab_bar.dart';

class TabBarTournament extends StatelessWidget {
  final TabController controller;

  const TabBarTournament({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      top: 10,
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          height: 50,
          child: Neumorphic(
            style: NeumorphicStyle(
              depth: 1,
              surfaceIntensity: 0.3,
              color: Theme.of(context).accentColor,
              intensity: 0.8,
              shape: NeumorphicShape.convex,
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(50)),
            ),
            child: TabBar(
              indicatorPadding: EdgeInsets.all(4),
              unselectedLabelColor: Colors.black,
              labelColor: Colors.black,
              indicator: NeumorphicDecoration(
                shape: NeumorphicBoxShape.roundRect(BorderRadius.circular(50)),
                isForeground: false,
                renderingByPath: false,
                splitBackgroundForeground: false,
                style: NeumorphicStyle(
                  depth: 1,
                  intensity: 1,
                  surfaceIntensity: 0.2,
                  color: Theme.of(context).primaryColorLight,
                  shape: NeumorphicShape.concave,
                  boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
                  lightSource: LightSource.topLeft,
                  shadowLightColor: Theme.of(context).accentColor,
                  shadowDarkColor: Colors.grey[400],
                ),
              ),
              labelPadding: EdgeInsets.all(0),
              controller: controller,
              tabs: [
                ItemAppBar(
                  icon: FontAwesomeIcons.info,
                  text: AppLocalizations.of(context)!.info,
                  drawDivider: true,
                ),
                ItemAppBar(
                  icon: FontAwesomeIcons.users,
                  text: AppLocalizations.of(context)!.teams,
                  drawDivider: true,
                ),
                ItemAppBar(
                  icon: FontAwesomeIcons.compressAlt,
                  text: AppLocalizations.of(context)!.matches,
                  drawDivider: true,
                ),
                ItemAppBar(
                  icon: FontAwesomeIcons.chartBar,
                  text: AppLocalizations.of(context)!.statistic,
                  drawDivider: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
